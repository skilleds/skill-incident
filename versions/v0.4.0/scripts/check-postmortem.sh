#!/usr/bin/env bash
# check-postmortem.sh — gate do postmortem blameless (schematize-incident).
#
# Motivo: postmortem sem timeline, sem impacto medido, sem dono+prazo nas ações ou que culpa
# pessoa vira literatura: o incidente volta. Este gate pega o que a máquina consegue ler.
# Entrada: $1 = arquivo .md de postmortem OU diretório (varre os .md que abrem com "# Postmortem").
# Saída: 0 = passa · 1 = reprova (achados em stdout) · 2 = nada para verificar (NÃO é aprovação).
# Waiver rastreável, por regra: `<!-- inc-ok: <regra> — <motivo> -->` no próprio arquivo.
# Regras: secao-ausente, timeline-curta, sem-mitigacao, impacto-sem-numero, acao-sem-dono,
#         acao-sem-prazo, sem-acoes, culpa-pessoa, dados-pessoais-indefinido, anpd-sem-decisao,
#         causa-sem-porques.
# strict-ok: COLETOR — varre todos os postmortems e soma os achados; com `set -e` o primeiro `grep` sem casamento (resultado normal) abortaria (`schematize-shell` -> `references/piso.md` secao 1)
set -uo pipefail

alvo="${1:-.}"
[ -e "$alvo" ] || { echo "check-postmortem: '$alvo' não existe" >&2; exit 2; }

arquivos=()
if [ -d "$alvo" ]; then
  while IFS= read -r f; do
    head -n 5 "$f" | grep -qiE '^# *postmortem' && arquivos+=("$f")
  done < <(find "$alvo" -type f -name '*.md' -not -path '*/.git/*' -not -path '*/versions/*' -not -path '*/templates/*' | sort)
else
  arquivos=("$alvo")
fi
if [ "${#arquivos[@]}" -eq 0 ]; then
  echo "check-postmortem: nenhum postmortem (arquivo .md iniciado por '# Postmortem') em '$alvo' — nada verificado" >&2
  exit 2
fi

# secao <arquivo> <regex do título>: imprime o corpo da seção "## ..." até a próxima "## ".
secao() {
  awk -v re="$2" '
    /^## / { dentro = (tolower($0) ~ re); next }
    dentro { print }
  ' "$1"
}

total=0
for f in "${arquivos[@]}"; do
  achados=()
  falha() { # falha <regra> <mensagem>
    if grep -qE "<!-- inc-ok: $1( |—|-|:)" "$f"; then return; fi
    achados+=("$1: $2")
  }

  for par in "resumo|resumo" "impacto|impacto" "timeline|(timeline|linha do tempo)" \
             "causa|(causa|fatores)" "acoes|(action items|ações|acoes)"; do
    nome="${par%%|*}"; re="${par#*|}"
    corpo="$(secao "$f" "$re")"
    if [ -z "$(printf '%s' "$corpo" | tr -d '[:space:]')" ]; then
      falha secao-ausente "seção '$nome' ausente ou vazia"
    fi
  done

  tl="$(secao "$f" '(timeline|linha do tempo)')"
  n=$(printf '%s\n' "$tl" | grep -cE '[0-9]{1,2}:[0-9]{2}')
  [ "$n" -ge 3 ] || falha timeline-curta "timeline com $n entradas datadas (mínimo 3: detecção, mitigação, resolução)"
  printf '%s' "$tl" | grep -qiE 'mitig|conten|rollback|revert' || falha sem-mitigacao "timeline sem o momento da mitigação (mitigar vem antes de diagnosticar)"

  im="$(secao "$f" 'impacto')"
  printf '%s' "$im" | grep -qiE '[0-9]+([.,][0-9]+)? ?(%|min|minutos|h\b|horas|ms|s\b|usuários|usuarios|clientes|requisi|req\b|erros|pedidos|transa|r\$|us\$|e-?mails|tenants|registros|falhas)' \
    || falha impacto-sem-numero "impacto sem número (quem, quanto, por quanto tempo)"

  ca="$(secao "$f" '(causa|fatores)')"
  printf '%s' "$ca" | grep -qiE 'por ?qu[eê]|fator(es)? contribuinte|porque' \
    || falha causa-sem-porques "causa sem cadeia de porquês nem fatores contribuintes"

  ac="$(secao "$f" '(action items|ações|acoes)')"
  linhas="$(printf '%s\n' "$ac" | grep -E '^\s*(\||- |\* |[0-9]+\.)' | grep -vE '^\s*\|[ :|-]+\|?\s*$' | grep -viE '^\s*\|\s*(id|#|ação|acao)\s*\|' || true)"
  if [ -z "$linhas" ]; then
    falha sem-acoes "nenhuma action item"
  else
    while IFS= read -r l; do
      [ -n "$l" ] || continue
      printf '%s' "$l" | grep -qE '@[A-Za-z0-9_-]+|[Dd]ono:? *[^ |]' || falha acao-sem-dono "sem dono (@handle ou 'dono: X'): ${l:0:70}"
      printf '%s' "$l" | grep -qE '[0-9]{4}-[0-9]{2}-[0-9]{2}' || falha acao-sem-prazo "sem prazo (AAAA-MM-DD): ${l:0:70}"
    done <<<"$linhas"
  fi

  # Blameless: sem culpa de pessoa. Heurística — o waiver exige motivo escrito.
  culpa="$(grep -nEi 'erro humano|human error|falha humana|culpa (d[oa]|dele|dela)|negligên|descuido|incompet|por causa d[oa] [A-Z][a-z]+|[A-Z][a-zé]+ (errou|esqueceu|cometeu|quebrou|derrubou|deletou|apagou|fez besteira)' "$f" | grep -vE 'inc-ok' | head -3 || true)"
  [ -z "$culpa" ] || falha culpa-pessoa "linguagem que culpa pessoa (${culpa%%$'\n'*}) — descreva o sistema que permitiu"

  # LGPD: o postmortem declara se houve dado pessoal; se sim, a decisão sobre ANPD/titulares.
  dp="$(grep -iE '^[-*]? *\**dados? pessoais?\**:' "$f" | head -1)"
  if [ -z "$dp" ]; then
    falha dados-pessoais-indefinido "faltou a linha 'Dados pessoais: sim|não' no cabeçalho"
  elif printf '%s' "$dp" | grep -qiE ': *\**(sim|yes)'; then
    grep -qiE '^[-*]? *\**anpd\**:.*([0-9]{4}-[0-9]{2}-[0-9]{2}|não comunicar|nao comunicar|sem risco|dispensad)' "$f" \
      || falha anpd-sem-decisao "houve dado pessoal mas falta 'ANPD: <data da comunicação | não comunicar + justificativa>'"
  fi

  if [ "${#achados[@]}" -gt 0 ]; then
    echo "REPROVADO  $f"
    for a in "${achados[@]}"; do echo "  - $a"; done
    total=$((total + ${#achados[@]}))
  else
    echo "ok         $f"
  fi
done

if [ "$total" -ne 0 ]; then echo "check-postmortem: $total achado(s)"; exit 1; fi
