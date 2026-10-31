#!/usr/bin/env bash
# Vermelho primeiro do gate check-postmortem.sh: cada caso planta UM defeito num postmortem válido.
# EXCEÇÃO DECLARADA (schematize-shell, strict mode): harness roda `set -u` sem `-e` para reportar
# todos os casos, em vez de parar no primeiro vermelho.
set -u
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
G="$AQUI/check-postmortem.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP:?}"' EXIT INT TERM
ok=0; fail=0

bom() { cat <<'FIX'
# Postmortem — INC-2026-001: Fila de pagamentos parada

- Severidade: SEV2
- Início (UTC): 2026-10-01T14:02Z
- Dados pessoais: não
- ANPD: n/a

## Resumo
Pagamentos ficaram sem processar por 28 minutos após um deploy.

## Impacto
- 1.200 clientes afetados (8% da base) por 28 minutos
- 3.400 requisições com erro

## Timeline
| Hora | Evento |
|---|---|
| 14:02 | Deploy começa |
| 14:09 | Alerta de burn-rate dispara |
| 14:21 | Mitigação: rollback da versão |
| 14:30 | Resolvido

## Causa e fatores contribuintes
1. Por quê a fila parou? O consumidor rejeitou o novo formato.
2. Por quê o formato passou? Não havia teste de contrato.
Fatores contribuintes: ausência de gate de contrato no CI.

## Action items
| ID | Ação | Dono | Prazo |
|---|---|---|---|
| A1 | Teste de contrato no CI | @maria | 2026-11-01 |
| A2 | Alerta de fila parada | @joao | 2026-11-08 |
FIX
}

# caso <nome> <exit esperado> <agulha> <sed-expr aplicado ao bom>
caso() {
  local nome="$1" esp="$2" agulha="$3" expr="$4" d="$TMP/$1"
  mkdir -p "$d"; bom | sed -E "$expr" >"$d/pm.md"
  local saida rc; saida="$(bash "$G" "$d/pm.md" 2>&1)"; rc=$?
  if [ "$rc" != "$esp" ]; then echo "  ✖ $nome: exit $rc, esperado $esp"; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  if [ -n "$agulha" ] && ! grep -qF -- "$agulha" <<<"$saida"; then echo "  ✖ $nome: saída sem \"$agulha\""; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  echo "  ✔ $nome"; ok=$((ok+1))
}

caso verde-completo 0 "ok" 's/^$/&/'
caso sem-impacto-numero 1 "impacto-sem-numero" 's/^- 1\.200 clientes.*/- Muitos clientes sofreram/; s/^- 3\.400 requisi.*/- Bastante erro/'
caso timeline-curta 1 "timeline-curta" '/^\| 14:09/d; /^\| 14:30/d'
caso sem-mitigacao 1 "sem-mitigacao" 's/Mitigação: rollback da versão/Diagnóstico segue/'
caso acao-sem-dono 1 "acao-sem-dono" 's/\| @maria \|/| time \|/'
caso acao-sem-prazo 1 "acao-sem-prazo" 's/2026-11-08/em breve/'
caso culpa-erro-humano 1 "culpa-pessoa" 's/^Pagamentos ficaram/Erro humano: pagamentos ficaram/'
caso culpa-nome 1 "culpa-pessoa" 's/^1\. Por quê a fila parou\?/1. Pedro esqueceu o teste. Por quê a fila parou?/'
caso sem-causa-porques 1 "causa-sem-porques" '/^1\. Por/d; /^2\. Por/d; /^Fatores/d; s/^## Causa.*/## Causa e fatores\nFoi o deploy./'
caso secao-ausente 1 "secao-ausente" 's/^## Resumo/## Nota/'
caso sem-dados-pessoais 1 "dados-pessoais-indefinido" '/^- Dados pessoais/d'
caso pessoal-sem-anpd 1 "anpd-sem-decisao" 's/^- Dados pessoais: não/- Dados pessoais: sim/; /^- ANPD/d'
caso pessoal-com-anpd 0 "ok" 's/^- Dados pessoais: não/- Dados pessoais: sim/; s/^- ANPD: n\/a/- ANPD: 2026-10-03 (comunicado em 2 dias úteis)/'
caso waiver 0 "ok" 's/^Pagamentos ficaram/Erro humano <!-- inc-ok: culpa-pessoa — citação literal do alerta --> pagamentos ficaram/'

# diretório sem postmortem: 2 (não é aprovação)
mkdir -p "$TMP/vazio"; echo "# README" >"$TMP/vazio/a.md"
bash "$G" "$TMP/vazio" >/dev/null 2>&1; rc=$?
if [ "$rc" = 2 ]; then echo "  ✔ diretorio-sem-postmortem (exit 2)"; ok=$((ok+1)); else echo "  ✖ diretorio-sem-postmortem: exit $rc"; fail=$((fail+1)); fi
# o template da skill deve passar no gate? Não: tem placeholders. Mas o bom do harness passa.
bash "$G" "$TMP/nao-existe" >/dev/null 2>&1; rc=$?
if [ "$rc" = 2 ]; then echo "  ✔ caminho-inexistente (exit 2)"; ok=$((ok+1)); else echo "  ✖ caminho-inexistente: exit $rc"; fail=$((fail+1)); fi

echo "check-postmortem.test: $ok ok, $fail falha(s)"
[ "$fail" -eq 0 ]
