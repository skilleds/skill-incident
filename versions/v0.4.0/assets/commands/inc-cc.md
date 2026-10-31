---
description: schematize-incident — context compact: grava o handoff no archive e roda /compact.
---
Antes de compactar, **grave o handoff** em `<projeto>/<projeto>_archive/context/` no par **context + checklist**
do padrão da `schematize-archive` (prefixo `AAAA-MM-DD-<slug>-`), FEITO vs ABERTO. Inclua: incidentes abertos
(SEV, IC, estado), postmortems pendentes, action items sem dono ou vencidos, waivers `inc-ok` e a decisão
LGPD/ANPD quando houver. Nunca inclua segredo nem dado pessoal. Só então rode `/compact`.
