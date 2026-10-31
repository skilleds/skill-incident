---
description: schematize-incident — monta o postmortem blameless a partir da timeline e roda o gate check-postmortem.sh
argument-hint: "<INC-AAAA-NNN | caminho da timeline>"
---

# /inc-postmortem — aprender sem culpar

Incidente: `${ARGUMENTS}`

1. Leia `references/postmortem.md` e a timeline viva. Parta de `assets/templates/postmortem.md`.
2. **Impacto com número** (quem, quanto, por quanto tempo) vindo da telemetria, não de memória. Não medido: diga
   "não medido" e abra action item de instrumentar.
3. **Causa:** cadeia de porquês até uma decisão de sistema + fatores contribuintes (gatilho, detecção, mitigação, raio).
   Pessoas por papel, nunca por nome; sem "erro humano".
4. **Action items:** 3 a 7, cada um com dono (`@handle`), prazo (`AAAA-MM-DD`) e tipo; prefira ação de máquina.
   Recorrência? Feche com ADR + piso + gate (`references/recorrencia.md`).
5. Grave em `<projeto>/<projeto>_archive/postmortems/AAAA-MM-DD-inc-NNN-<slug>.md`.
6. **Rode o gate:** `bash .claude/skills/schematize-incident/scripts/check-postmortem.sh <arquivo>` até sair 0.
7. Entregue o caminho, o resultado do gate e as ações para o overdev (`schematize overdev delegar`).
