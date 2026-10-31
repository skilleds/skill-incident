---
description: schematize-incident — revisa postmortem e action items: roda o gate e lê o que a máquina não lê
argument-hint: "<arquivo ou pasta de postmortems>"
---

# /inc-review — o texto passa; o argumento presta?

Alvo: `${ARGUMENTS}`

1. `bash .claude/skills/schematize-incident/scripts/check-postmortem.sh ${ARGUMENTS}` — reprovou, corrija antes de opinar.
2. Leia o que a máquina não lê:
   - **Blameless de verdade:** a causa termina em decisão de sistema ou em pessoa disfarçada de "falta de atenção"?
   - **Os porquês** chegam a algo que um gate, teste ou alerta teria pego?
   - **Detecção:** quanto tempo entre início do impacto e alerta (TTD)? Existe action item para encurtar?
   - **Ações:** são de máquina? São poucas e ranqueadas? Há item vencido sem justificativa?
   - **Recorrência:** já houve incidente da mesma classe? Se sim, ADR + piso + gate existem?
   - **LGPD:** a decisão sobre dado pessoal e ANPD está escrita e justificada?
   - **Higiene:** sem segredo, sem dado pessoal, sem nome de pessoa.
3. Entregue achados por gravidade, com o trecho e a correção. Waiver `inc-ok` só com motivo escrito.
