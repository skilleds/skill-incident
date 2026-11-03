# Postmortem blameless

> O objetivo não é achar o culpado; é achar o que **no sistema** permitiu que uma pessoa
> razoável, com a informação que tinha, fizesse aquilo. Culpar pessoa ensina o time a esconder.

## 1. Quando e quem

- **SEV1/SEV2: obrigatório**, reunião em até 5 dias úteis; documento rascunhado a partir da timeline viva.
- SEV3: curto, assíncrono, se houve aprendizado. SEV4: não precisa.
- Quem escreve: o IC (ou o escriba) com o dono do serviço; quem estava no fogo revisa, não escreve sozinho.
- Mora em `<projeto>/<projeto>_archive/` (`schematize-archive`), arquivo `postmortems/AAAA-MM-DD-inc-NNN-<slug>.md`;
  a decisão derivada vira ADR em `decisoes/ADR-NNNN-<slug>.md` (`schematize-docs → references/adr.md`).

> **Desvios de acesso:** registre todo uso de break-glass, ação fora do ops ou comando que faltou
> no ops (pisos 23-24 da `schematize-engineering`); a ação de prevenção é implementar a operação
> no repo do ops, via git.

## 2. Estrutura (molde em `assets/templates/postmortem.md`)

Cabeçalho (severidade, janela, IC, **Dados pessoais**, **ANPD**, **Dado perdido**) · Resumo · Impacto quantificado ·
Timeline · Causa e fatores contribuintes (cadeia de porquês) · O que funcionou e o que não · Action items · Recorrência.

> **Fila/dado:** se o incidente envolveu fila, DLQ, outbox ou backlog, o cabeçalho traz
> `Dado perdido: sim|não` com a **prova** (contagem entrou/saiu, DLQ triada, reentrega idempotente
> conferida — piso 28). O gate cobra a linha quando o texto menciona fila/DLQ/outbox/backlog.
> Publique o postmortem com commit + push na hora (piso 22).

## 3. Impacto quantificado

O gate exige **escopo + duração** (ex.: "1.200 clientes por 28 min"); "1 erro" não passa.

"Alguns clientes ficaram sem pagar" não é impacto. É: **1.200 clientes (8%) por 28 min, 3.400 requisições
com erro, R$ 12 mil de receita retardada, 22% do error budget mensal**. Números vêm do SLI/telemetria
(`schematize-observability`), não de memória. Não sabe? Escreva "não medido" e abra action item de instrumentar.

## 4. Causa: 5 porquês e fatores contribuintes

- Cadeia de porquês até chegar a uma decisão **de sistema** (processo, ferramenta, ausência de teste,
  alerta, revisão). "Porque Fulano errou" não é resposta: é a pergunta seguinte ("por que o sistema deixou?").
- **Raramente há causa raiz única.** Liste fatores contribuintes: o gatilho, a latência de detecção,
  o que atrasou a mitigação, o que ampliou o raio.
- Descreva pessoas por **papel** ("o operador de plantão"), nunca por nome, e ações por **informação disponível na hora**.
- Vocabulário vetado: "erro humano", "falha humana", "negligência", "descuido", "Fulano esqueceu/errou/derrubou". O gate
  acusa; waiver só para citação literal, com motivo.

## 5. Action items que se fecham

Cada item: **dono (@handle), prazo (AAAA-MM-DD), tipo** (prevenir · detectar · mitigar · processo) e critério de pronto.
- Prefira ação **de máquina** (gate, teste, alerta, limite, automação) a ação de atenção ("avisar o time", "ter mais cuidado"):
  atenção humana é o regime que falhou.
- Poucos e bons: 3 a 7. Ranqueie por quanto reduz a chance **ou** o raio do próximo incidente.
- Entram no checklist do projeto e no overdev (`schematize overdev delegar`) com o mesmo dono e prazo; revisão semanal até zerar.
- Item vencido sem justificativa reabre o incidente para fins de métrica.

## 6. O gate

`bash scripts/check-postmortem.sh <arquivo|pasta>` — 0 passa · 1 reprova · 2 nada para verificar.
Regras: `secao-ausente`, `timeline-curta`, `sem-mitigacao`, `impacto-sem-numero`, `causa-sem-porques`,
`sem-acoes`, `acao-sem-dono`, `acao-sem-prazo`, `culpa-pessoa`, `dados-pessoais-indefinido`, `anpd-sem-decisao`, `dado-perdido-indefinido`.
Waiver por regra: `<!-- inc-ok: <regra> — <motivo> -->`. O gate lê estrutura, não verdade: um texto
formalmente ok ainda precisa de revisão humana do argumento.

## 7. Métricas que vale acompanhar

TTD (início do impacto -> detecção), TTM (detecção -> mitigação), TTR (resolução), nº de incidentes por
SEV, % de action items fechados no prazo, % de incidentes **recorrentes** (meta: zero).
