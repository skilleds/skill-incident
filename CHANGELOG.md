# Changelog — schematize-incident

Todas as mudanças relevantes deste pacote, no formato [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
com versionamento [SemVer](https://semver.org/lang/pt-BR/).

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
