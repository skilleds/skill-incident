# Comunicação: status page, cliente, interna

> Silêncio parece pior que o problema. O cliente perdoa falha; não perdoa descobrir pelo concorrente
> ou pelo Twitter que você já sabia.

## 1. Ritmo

| SEV | Primeira nota | Cadência | Quem |
|---|---|---|---|
| SEV1 | até 15 min da declaração | a cada 30 min, mesmo "sem novidade" | Comms |
| SEV2 | até 30 min | a cada 60 min | Comms |
| SEV3 | quando relevante ao cliente | na mudança de estado | dono |

Toda nota termina com **a hora da próxima atualização**, e ela é cumprida.

## 2. Estados da status page

`Investigando` -> `Identificado` -> `Monitorando` -> `Resolvido`. Modelo em
`assets/templates/status-update.md`. Regras:

1. Linguagem do cliente: o que **ele** não consegue fazer, não o nome do microserviço.
2. **Não especule causa** e **não nomeie pessoa** ou fornecedor sem confirmação.
3. Fuso explícito; sem prazo de resolução que você não pode cumprir ("estimamos" só com base).
4. Nada de dado de outro cliente ou detalhe explorável (segurança).
5. Status page **hospedada fora da infra afetada** (se ela cai junto, ninguém avisa ninguém).

## 3. Cliente e interna

- **Cliente afetado, SEV1/2**: aviso ativo (e-mail/in-app) com impacto, contorno, próximo contato; depois, o resumo
  do postmortem (sem nome de pessoa, sem segredo) quando houver compromisso contratual de SLA.
- **Interna**: canal de atualização para suporte/comercial/direção com o mesmo texto da status page + o
  que dizer e **o que não dizer**. Suporte nunca fica sem a nota.
- **Imprensa/redes**: só pessoa designada; nada improvisado.
- Crédito/SLA contratual: calcule do tempo medido na timeline, não de memória.

## 4. Efeito externo na própria comunicação

Aviso em massa ao cliente é **efeito externo**: fora de prd vai para sink; em prd tem cap e revisão
de segundos antes de enviar. Um incidente não pode gerar o próximo (e-mail errado a toda a base).

<!-- herdado:engineering/efeito-externo:invariantes -->**Cap por execução** (`MAIL_MAX_PER_RUN`, default 50) com abort; **fail-closed** (ambiente ausente/desconhecido ⇒ não-prd; só o valor exato de produção entrega de verdade); **chave sandbox** fora de prd. Todo endereço sintético (fixture, seed, persona, demo, carga) é `<papel>+<run-id>-<n>@test.<domain>` — domínio em **rota nula** (null MX RFC 7505 + SPF `-all` + DMARC `p=reject`) ou TLD reservado (`.test`/`.invalid`/`.example`); **VETADO** `@gmail.com`, domínio de cliente/terceiro, e-mail de pessoa real (**inclusive o seu**) e o domínio de produção. A recusa é **erro**, nunca warning nem sucesso silencioso. Entregar de verdade fora de prd exige **as cinco** (ADR + allowlist ≤5 + cap + janela + subdomínio separado). Motivo: bounce/complaint em massa **queima IP e domínio** e derruba o transacional de prd — inclusive o **OTP de login** — com semanas de warm-up e utilidade zero (o incidente dos 5.000 e-mails só existiu porque nada contava).<!-- /herdado -->
