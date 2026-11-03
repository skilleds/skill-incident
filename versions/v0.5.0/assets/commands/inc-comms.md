---
description: schematize-incident — redige a atualização de status (status page, cliente, interna) no ritmo da severidade
argument-hint: "<estado: investigando|identificado|monitorando|resolvido>"
---

# /inc-comms — silêncio é falha

Estado: `${ARGUMENTS}`

1. Leia `references/comunicacao.md` e a timeline atual; confirme SEV e cadência.
2. Redija a nota a partir de `assets/templates/status-update.md`: o que o **cliente** não consegue fazer, o que
   estamos fazendo, **hora da próxima atualização** (obrigatória).
3. Vetos: causa especulativa, nome de pessoa ou fornecedor sem confirmação, prazo sem base, dado de outro
   cliente, detalhe explorável.
4. Entregue 3 versões: status page (curta), cliente afetado (com contorno) e interna (com o que dizer e o que NÃO dizer).
5. Envio em massa é efeito externo: fora de prd só ao sink; em prd, cap e revisão antes de enviar. Não envie sem aprovação do IC.
