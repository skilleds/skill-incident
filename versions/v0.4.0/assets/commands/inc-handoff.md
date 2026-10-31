---
description: schematize-incident — gera o handoff (context.md + checklist.md) no archive, sem compactar.
---
Gere o handoff em `<projeto>/<projeto>_archive/context/`: `AAAA-MM-DD-<slug>-context.md` (incidente em curso,
SEV, IC, estado da mitigação, decisões, timeline até aqui, o que o gate acusou) e
`AAAA-MM-DD-<slug>-checklist.md` (FEITO vs ABERTO, nas três classes: `- [ ]` máquina · `- [H ]` humano · `- [~]` on-hold).
Não compacte, só grave. Nunca grave segredo nem dado pessoal no handoff.
