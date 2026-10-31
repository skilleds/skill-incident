---
description: schematize-incident — carrega à força TODO o corpo normativo de resposta a incidente e passa a aplicá-lo nesta sessão.
---
Carregue **agora** o corpo normativo da skill `schematize-incident`. A partir daqui, nesta sessão, isto **não é opcional**.

1. **Leia na íntegra, sem trabalhar de memória.** Caminho: `.claude/skills/schematize-incident/references/*.md`
   (projeto) ou `~/.claude/skills/schematize-incident/references/*.md` (global):
   - `severidade.md` — SEV1-4 por critério objetivo; dado pessoal = SEV1 até provar o contrário.
   - `papeis-e-comando.md` — IC, ops, comms, escriba; canal; timeline; passagem de comando.
   - `mitigacao.md` — estancar antes de diagnosticar; alavancas; o que é proibido; declarar o fim.
   - `comunicacao.md` — status page, cliente, interna; cadência; efeito externo na comunicação.
   - `lgpd.md` — gatilho, relógio da ANPD, levantamento e registro da decisão.
   - `postmortem.md` — blameless, impacto quantificado, porquês, action items, gate.
   - `recorrencia.md` — ADR + piso + gate quando o incidente volta.
   - `stack-versoes.md` — anexo volátil (prazos e fatos com data e fonte).
2. **Se houver postmortem no repo**, rode o gate:
   `bash .claude/skills/schematize-incident/scripts/check-postmortem.sh <pasta-do-archive>/postmortems`
3. **Aplique daqui em diante** e diga qual piso está aplicando quando ele mudar o que você ia fazer.
   Nunca tome ação destrutiva em produção sem decisão registrada do IC.
