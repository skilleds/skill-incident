---
description: Mapa da skill schematize-incident (resposta a incidente: SEV, comando, mitigação, comunicação, LGPD, postmortem blameless).
---
**schematize-incident** — incidente comandado, comunicado, aprendido e não repetido.

| Comando | O que faz |
|---|---|
| `/inc-help` | esta lista |
| `/inc-load` | carrega à força TODO o corpo normativo (severidade, papéis, mitigação, comunicação, LGPD, postmortem, recorrência) e passa a aplicá-lo |
| `/inc-declare` | declara incidente: SEV pela tabela, papéis, canal e timeline |
| `/inc-comms` | redige a atualização de status no ritmo da severidade |
| `/inc-lgpd` | avalia dado pessoal, levanta fatos e registra a decisão ANPD/titulares |
| `/inc-postmortem` | monta o postmortem blameless e roda `scripts/check-postmortem.sh` |
| `/inc-review` | revisa postmortem e action items (gate + leitura do que a máquina não lê) |
| `/inc-claude` | cria ou mescla o `CLAUDE.md` sempre-on de resposta a incidente |
| `/inc-cc` · `/inc-handoff` | context compact / handoff no archive |

Pareia com: `schematize-observability` (detectar/alertar), `schematize-infra` (DR), `schematize-docs` (runbook, ADR),
`schematize-archive` (onde o postmortem mora), `schematize-pentest` (segurança ofensiva).
