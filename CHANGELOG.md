# Changelog — schematize-incident

Todas as mudanças relevantes deste pacote, no formato [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
com versionamento [SemVer](https://semver.org/lang/pt-BR/).

## [Não lançado]
### Corrigido
- P1-23 `references/mitigacao.md`: alavanca "drenar/replay de DLQ ou outbox" (operação do ops, dry-run,
  idempotência, taxa limitada), nova §2d com o critério de "mitigado" para backlog (profundidade/idade em
  queda, sem perda nem duplicata, entrou N = saiu N) e item no postmortem ("Dado perdido: sim|não + prova").
- P1-24 `mitigacao.md` §2c: hotfix/rollforward segue dev -> git -> hml -> prd, entra pelo git, CI remoto
  uma vez (tag `hml-*`); pular hml é decisão registrada do IC; nunca pular o git.
- P1-25 `papeis-e-comando.md` §3: relatório a cada 30 min e handoff do IC no archive, commit+push na hora;
  postmortem também sobe na hora (piso 22).
- P2-7 `scripts/check-postmortem.sh` endurecido, com teste vermelho para cada furo: impacto exige escopo E
  duração ("1 erro" reprova); timeline conta só horários distintos, válidos, no início da linha e com
  descrição; nova regra `dado-perdido-indefinido` (fila/DLQ/outbox/backlog exige "Dado perdido"). 25 casos.
- P2-5 `stack-versoes.md`: Grafana OnCall OSS marcado como arquivado (README: manutenção 2025-03-11,
  arquivado 2026-03-24; banner do GitHub: 2026-06-05; fonte diverge); prazos ANPD seguem `reverificar`.
- `recorrencia.md` e pisos: "gate no CI" virou gate local por commit + CI de promoção.

### Adicionado
- Bloco herdado "Herda os pisos 22–29 da `schematize-engineering`" em `SKILL.md` e `assets/CLAUDE.md`.
- Template de postmortem com a linha `Dado perdido`.

## [0.4.0] — 2026-10-31
### Adicionado
- `references/mitigacao.md` §2b: a IA não executa mitigação direta na VPS; mitiga por operação do ops
  (rollback/restart/flag); break-glass é humano e auditado; falta de comando vira PR no ops.
- `references/postmortem.md`: registro obrigatório de desvios de acesso.
- Porquê: alinhamento aos pisos 23-24 da `schematize-engineering`.

### Mantido (piso inalterado)
- SEV, papéis, LGPD, comunicação; `description` inalterada.

## [0.3.0] — 2026-10-15
### Alterado
- Fronteira e `references/recorrencia.md` apontam para `schematize-regression`: o postmortem exige o teste
  de regressão (visto vermelho antes do fix) e o `git bisect` do commit culpado; o COMO fica lá.
- Porquê: a ação de prevenção "teste que reproduz" não tinha dona do procedimento.

## [0.2.1] — 2026-10-14
Ponteiro para a skill nova `schematize-bots` (piso curto, sem duplicar).

### Alterado
- ponteiro para spam em massa e token de bot vazado.

## [0.2.0] — 2026-10-14
Integração ao catálogo: orçamento de description e ponteiros entre as irmãs novas.

### Corrigido

- `check-postmortem.sh` declara a exceção de strict mode (coletor) e sai com o status real, sem `exit 0` incondicional.

### Alterado
- `description` <=190 (era 247; o gate avisava).
- Segredo vazado: `severidade.md` e a fronteira citam `/git-leak` (`schematize-git`); banco em incidente aponta `schematize-postgres`.
- Motivo: o catálogo estourou o orçamento de listagem com 45 skills; cada fronteira aponta a dona em vez de duplicar.

## [0.1.0] — 2026-10-14
Primeira versão. Faltava a dona do ciclo humano do incidente: a observabilidade detecta, a infra recupera, mas
ninguém mandava classificar, comandar, comunicar, tratar dado pessoal e aprender. O incidente dos 5.000 e-mails
(2026-08) mostrou o custo de fechar incidente com conselho em vez de ADR + piso + gate.

### Adicionado
- `SKILL.md` com 12 pisos, fronteira com observability/infra/docs/archive/pentest/iam e 9 comandos `/inc-*`.
- `references/`: severidade (SEV1-4), papéis e comando, mitigação, comunicação, LGPD/ANPD, postmortem blameless, recorrência e anexo volátil.
- `scripts/check-postmortem.sh` (+ teste com 16 casos, vermelhos plantados): seções, timeline, mitigação, impacto numérico, porquês, dono e prazo nas ações, linguagem de culpa, decisão LGPD/ANPD; waiver `inc-ok`.
- `assets/templates/`: postmortem, timeline viva, atualização de status.
