---
description: schematize-incident — declara incidente: classifica SEV pela tabela, nomeia IC/comms/ops/escriba, abre canal e timeline
argument-hint: "<o que está acontecendo, em uma frase>"
---

# /inc-declare — comandar antes de depurar

Incidente: `${ARGUMENTS}`

1. **Classifique em 60 s** com `references/severidade.md`. Dado pessoal possivelmente envolvido -> SEV1 e
   rode `/inc-lgpd` em paralelo. Na dúvida, suba um nível.
2. **Nomeie os papéis** (`references/papeis-e-comando.md`): IC, ops, comms, escriba. IC e ops nunca são a mesma
   pessoa em SEV1/2. Quem declara é IC até passar o comando explicitamente.
3. **Abra** o canal `#inc-AAAA-NNN` e a timeline (`assets/templates/timeline.md`). Primeira linha: início do
   impacto (do gráfico), detecção, declaração.
4. **Mitigue antes de diagnosticar** (`references/mitigacao.md`): o que mudou na última hora? Reverter vem
   antes de teorizar. Uma alavanca por vez, narrada. Ação destrutiva só com decisão registrada do IC.
5. **Comunicação:** primeira nota no prazo da severidade (`/inc-comms`).
6. Entregue: SEV, papéis, canal, hipótese inicial, primeira ação de mitigação e a hora da próxima atualização.
