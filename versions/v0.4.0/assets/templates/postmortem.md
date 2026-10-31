# Postmortem — INC-AAAA-NNN: <título factual, sem nome de pessoa>

- Severidade: SEV<1-4>
- Início (UTC): AAAA-MM-DDTHH:MMZ
- Fim (UTC): AAAA-MM-DDTHH:MMZ
- Comandante (IC): @handle
- Dados pessoais: não
- ANPD: n/a

## Resumo
Duas ou três frases: o que o usuário viu, por quanto tempo, como acabou.

## Impacto
- Usuários/tenants afetados: N (X% da base)
- Duração do impacto: N min
- Requisições com erro: N (X%)
- Dinheiro, SLO e error budget consumidos: R$ N · N% do budget mensal

## Timeline
Horários em UTC. Um fato por linha, sem adjetivo.

| Hora | Evento |
|---|---|
| 14:02 | Deploy da versão X começa |
| 14:09 | Alerta dispara (detecção) |
| 14:15 | IC declarado, canal aberto |
| 14:21 | Mitigação: rollback da versão X |
| 14:30 | Resolvido: métricas normais por 10 min |

## Causa e fatores contribuintes
Causa imediata, depois a cadeia de porquês (pare quando chegar a uma decisão de sistema, não de pessoa):
1. Por quê ...
2. Por quê ...
3. Por quê ...

Fatores contribuintes: o que tornou o incidente possível ou pior (processo, ferramenta, ausência de gate).

## O que funcionou e o que não funcionou
- Funcionou: ...
- Não funcionou: ...
- Sorte: ...

## Action items
| ID | Ação | Dono | Prazo | Tipo |
|---|---|---|---|---|
| A1 | Gate no CI que barra X | @handle | 2026-11-01 | prevenir |
| A2 | Alerta de burn-rate para Y | @handle | 2026-11-08 | detectar |

## Recorrência
É a segunda vez? Se sim: ADR + piso + gate de máquina (link). Se não: por que não vai voltar sem aviso?
