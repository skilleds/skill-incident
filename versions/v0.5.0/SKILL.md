---
name: schematize-incident
metadata:
  version: 0.5.0
description: >-
  Resposta a incidente: SEV1-4 objetivo, papéis (IC, comms), mitigar antes de diagnosticar, LGPD/ANPD, postmortem blameless. Use ao declarar incidente. Alertas: schematize-observability.
---
<!-- cross-skill: observabilidade.md, efeitos-externos.md -> schematize-engineering -->

# Resposta a incidente (schematize-incident)

Incidente é certo; o que se escolhe é se ele é **comandado ou caótico**, e se **ensina ou se repete**.
Esta skill é a dona do ciclo humano do incidente: classificar, comandar, mitigar, comunicar, tratar dado
pessoal, aprender (postmortem blameless) e **impedir a volta** (incidente recorrente vira ADR + piso + gate).
Detectar e alertar é da `schematize-observability`; recuperar de desastre é da `schematize-infra`.

**Versão:** skill `schematize-incident` v0.5.0. Changelog em `CHANGELOG.md`.

## Precedência e herança (leia antes de divergir)

<!-- herdado:engineering/precedencia:dominio intro="Esta skill é **transversal** (não é linguagem): o ciclo de resposta a incidente sobre a operação que a base exige (`schematize-engineering` → `references/operacao.md`). **Onde divergir da base em piso, a base manda**; aqui mora o *como*, o rito e o gate." cmd="inc" -->Esta skill é **transversal** (não é linguagem): o ciclo de resposta a incidente sobre a operação que a base exige (`schematize-engineering` → `references/operacao.md`). **Onde divergir da base em piso, a base manda**; aqui mora o *como*, o rito e o gate.

1. **Onde esta skill divergir da base, a BASE MANDA.** Aqui mora a especialização do domínio ou da
   ferramenta — o como, o padrão, o gate. Divergência de *piso* é defeito desta skill, não variante local.
2. **O que não está repetido aqui é HERDADO, não dispensado.** Esta skill herda os pisos da base e
   os comandos dela cobrem o **domínio**, não o piso geral. Valem integralmente, sem cópia local:
   - **§28 Archive** — `<projeto>/<projeto>_archive/` é **repositório git próprio, PRIVADO e
     obrigatório**, criticidade 0 (`schematize-archive`).
   - **§35 Definition of Done** e a lista de anti-padrões (citada por **título**, nunca por número).
   - **§39 Índice/MAPA** — enumeração exaustiva (uma entrada por unidade chamável, `M == N`) e grafo
     com arestas em ASCII (`A -> B`), nunca a seta unicode.
   - **IAM** (`schematize-engineering` → `references/iam.md`): identidade ≠ email, ≥2 fatores, ReBAC
     multi-tenant, argon2id-only para senha nova, sessão longa e logout irreversível.
   - **Efeito externo** nunca sai de não-produção (`schematize-engineering` →
     `references/efeitos-externos.md`).
   - **Orquestração** (`schematize-engineering` → `references/orquestracao.md` §9): o principal não
     desenvolve (é Claude Opus); executor mais barato que resolve — `haiku`/`sonnet` → Codex Terra → Cursor → `opus` só após falha; visual direto ao Codex; imagem nunca pelo Claude: detecta Codex/Gemini e pergunta ao usuário qual usar (Codex é a sugestão, não automática), nunca API paga.
3. **QA, ops, IAM e índice não têm comando próprio aqui:** vêm da base `/eng-*`. Para trabalho
   contínuo use `/eng-overdev`; para planejar `/eng-plan`; para varrer a base `/eng-scan`; para
   revisão geral `/eng-review` (e `/eng-ops`, `/eng-iam`, `/eng-index`). Os comandos
   `/inc-*` cobrem o domínio desta skill; o piso geral é o da base.<!-- /herdado -->

## Fronteira com as outras skills

| Assunto | Dono | Ponteiro |
|---|---|---|
| **Ciclo do incidente**: SEV, papéis, canal, mitigação, comunicação, LGPD, postmortem, recorrência | **esta skill** | `references/*.md` abaixo |
| Detectar e alertar: SLI/SLO, burn-rate, alerta com runbook, dashboards | `schematize-observability` | `schematize-observability → references/slo-alertas.md` |
| DR, backup/restore, failover, isolamento, rede | `schematize-infra` | `schematize-infra → references/resiliencia.md` |
| Formato de runbook e de ADR | `schematize-docs` | `schematize-docs → references/runbooks.md`, `references/adr.md` |
| Onde o postmortem mora (`<projeto>_archive/`), handoff | `schematize-archive` | repositório privado, criticidade 0 |
| Exploração/segurança como achado; teste de intrusão | `schematize-pentest` | lado ofensivo; aqui só a resposta |
| Teste de regressão do incidente (vermelho antes do fix), `git bisect` do commit culpado | `schematize-regression` | `schematize-regression → references/incidente-e-metricas.md`, `references/bisect.md`; aqui só se exige que exista (postmortem) |
| Segredo commitado/credencial no repo: rito de rotação e limpeza | `schematize-git` | `/git-leak`; `schematize-git → references/segredos.md` |
| Identidade, sessão, revogação de credencial | `schematize-iam` | `schematize-iam` (revogar tokens/chaves é ação de mitigação) |
| Efeito externo indevido (e-mail em massa, cobrança, webhook) | base | `schematize-engineering → references/efeitos-externos.md` |
| Operar o banco no incidente (failover, restore, PITR) | `schematize-postgres` | `schematize-postgres → references/replicacao-e-failover.md`, `backup-e-pitr.md` |
| Rollback de migração | `schematize-database` | expand-contract: o que permite voltar |

## Comandos (Claude Code)

| Comando | O que faz |
|---|---|
| `/inc-help` | lista os comandos |
| `/inc-load` | carrega à força o corpo normativo (severidade, papéis, mitigação, comunicação, LGPD, postmortem, recorrência) |
| `/inc-declare` | declara incidente: classifica SEV pela tabela, nomeia IC/comms/ops/escriba, abre canal e timeline |
| `/inc-comms` | redige a atualização de status (status page, cliente, interna) no ritmo da severidade |
| `/inc-lgpd` | avalia o gatilho de dado pessoal, levanta os fatos e registra a decisão sobre ANPD/titulares |
| `/inc-postmortem` | monta o postmortem blameless a partir da timeline e roda o gate |
| `/inc-review` | revisa postmortem e action items: gate + o que a máquina não lê (blameless de verdade, recorrência) |
| `/inc-claude` | cria/mescla o `CLAUDE.md` sempre-on de resposta a incidente |
| `/inc-cc` · `/inc-handoff` | context compact / handoff arquivado |

## Como usar

1. **Classifique em 60 s** pela tabela (`references/severidade.md`); na dúvida, suba um nível.
2. **Um IC, um canal, uma timeline** (`references/papeis-e-comando.md`).
3. **Mitigue antes de diagnosticar** (`references/mitigacao.md`): reverter o último que mudou, uma alavanca por vez.
4. **Comunique no ritmo** (`references/comunicacao.md`); dado pessoal abre `references/lgpd.md` em paralelo.
5. **Postmortem blameless** com impacto medido e ações com dono e prazo (`references/postmortem.md`):
   `bash scripts/check-postmortem.sh <arquivo|pasta>`; `0` passa, `1` reprova, `2` nada para verificar (não é aprovação).
6. **Se voltar, feche com ADR + piso + gate** (`references/recorrencia.md`).

| Tarefa | Reference |
|---|---|
| SEV1-4: critério objetivo, regras de classificação | `references/severidade.md` |
| IC, ops, comms, escriba; canal; timeline; passagem de comando | `references/papeis-e-comando.md` |
| Estancar: rollback, flag, desvio de tráfego; o que é proibido; declarar o fim | `references/mitigacao.md` |
| Status page, cliente, interna; cadência; efeito externo na própria comunicação | `references/comunicacao.md` |
| Dado pessoal: gatilho, relógio ANPD, levantamento, registro da decisão | `references/lgpd.md` |
| Postmortem: estrutura, impacto, porquês, action items, métricas, gate | `references/postmortem.md` |
| Recorrência: ADR + piso + gate | `references/recorrencia.md` |
| Prazos e fatos de terceiros, com data e fonte (anexo volátil) | `references/stack-versoes.md` |

Assets: `assets/templates/postmortem.md` · `assets/templates/timeline.md` · `assets/templates/status-update.md`.

## Pisos inegociáveis (vetam o atalho)

1. **Severidade por critério objetivo**, não por humor; na dúvida sobe um nível; reclassificação é dita e registrada.
2. **Um IC por incidente**, que não mexe no sistema em SEV1/2; passagem de comando explícita.
3. **Mitigar antes de diagnosticar:** estancar primeiro (reverter o último que mudou), uma alavanca por vez, tudo narrado no canal. A IA não mitiga direto na VPS: só por operação do ops (rollback/restart/flag); break-glass é humano e auditado; desvio vai pro postmortem (`mitigacao.md` §2b).
4. **Ação destrutiva e irreversível só por decisão registrada do IC**, com rollback pensado antes.
5. **Silêncio é falha:** SEV1/2 tem primeira nota e cadência fixas, terminando com a hora da próxima. Status page fora da infra afetada.
6. **Dado pessoal exposto é SEV1 até provar o contrário** e abre o relógio da LGPD/ANPD na hora; a decisão (comunicar ou não, com justificativa) é escrita.
7. **Postmortem blameless obrigatório em SEV1/2**, com timeline, impacto **quantificado**, cadeia de porquês e fatores contribuintes; sem nome de pessoa nem "erro humano".
8. **Action item tem dono e prazo**, e prefere ação de máquina (gate, teste, alerta) à de atenção.
9. **Incidente recorrente vira ADR + piso + gate** (local por commit e CI de promoção); "tomar mais cuidado" não fecha incidente.
10. **Postmortem mora no archive** (`<projeto>/<projeto>_archive/`), nunca só em chat ou wiki solta; nunca contém segredo nem o dado pessoal vazado.
11. **Aviso em massa ao cliente é efeito externo:** sink fora de prd, cap e revisão em prd. <!-- herdado:engineering/efeito-externo:invariantes -->**Cap por execução** (`MAIL_MAX_PER_RUN`, default 50) com abort; **fail-closed** (ambiente ausente/desconhecido ⇒ não-prd; só o valor exato de produção entrega de verdade); **chave sandbox** fora de prd. Todo endereço sintético (fixture, seed, persona, demo, carga) é `<papel>+<run-id>-<n>@test.<domain>` — domínio em **rota nula** (null MX RFC 7505 + SPF `-all` + DMARC `p=reject`) ou TLD reservado (`.test`/`.invalid`/`.example`); **VETADO** `@gmail.com`, domínio de cliente/terceiro, e-mail de pessoa real (**inclusive o seu**) e o domínio de produção. A recusa é **erro**, nunca warning nem sucesso silencioso. Entregar de verdade fora de prd exige **as cinco** (ADR + allowlist ≤5 + cap + janela + subdomínio separado). Motivo: bounce/complaint em massa **queima IP e domínio** e derruba o transacional de prd — inclusive o **OTP de login** — com semanas de warm-up e utilidade zero (o incidente dos 5.000 e-mails só existiu porque nada contava).<!-- /herdado -->
12. <!-- herdado:engineering/orquestracao:curto -->**Orquestrador não desenvolve; subagent barato executa.** O agent principal só planeja, despacha e revisa; ação onerosa vira micro-tasks para o executor mais barato que resolve: `haiku` (mecânico) / `sonnet` (código; falhou → mesmo subagent corrige, até 2 rodadas) → Codex `gpt-5.6-terra` → Cursor → subagent `opus` (motivo) → `park`; **visual vai direto ao Codex**; **imagem nunca pelo Claude: detectar Codex/Gemini e perguntar ao usuário qual usar (Codex é a sugestão), nunca API de imagem paga**; papéis em `agentes.toml`. No overdev, cada item do checklist vai a um subagent e o principal revisa antes do `- [x]`. **Sem frota ociosa:** idle com pendência volta ao trabalho; dependente de outro agent → mata e enfileira com gatilho; terminou → mata (§9.6). Detalhe: `schematize-engineering` → `references/orquestracao.md` §9.<!-- /herdado -->

<!-- herdado:engineering/pisos-22-29:bloco -->**Herda os pisos 22–29 da `schematize-engineering`** (texto completo em `assets/CLAUDE.md` dela): 22 tudo no git — sem remote, push falho ou HEAD≠origin a demanda NÃO se conclui; 23 deploy só do git (VETADO scp/rsync/tar|ssh/docker save|load/git bundle); 24 o ops é o gate da IA — a IA nunca muda a VPS direto nem escreve SQL, só operação nomeada (`ssh vps "ops <op>"`); 25 sem agents inúteis (entregou, morreu); 26 relatório a cada 30 min e handoff a cada 6 h; 27 CI remoto só antes do hml, a pedido ou em tag (`workflow_dispatch` + `hml-*`/`v*`; VETADO `pull_request`, `push` em branch, `workflow_run`, cron sem justificativa); 28 microserviço autônomo (fila durável + 7 testes de resiliência); 29 build/teste na máquina dev/hml quando existe (ponte só no workspace de build, nunca prd) + higiene (`scripts/higiene.sh`).<!-- /herdado -->

## Regra de mídia

Diagramas do postmortem vão em Mermaid ou texto. Imagem ou mídia gerada **nunca** por modelo Claude:
detecte Codex e Gemini disponíveis e **pergunte ao usuário qual usar**. Nenhum disponível: avise sem rodeio
que visual gerado pelo Claude tem qualidade inversamente proporcional à de código (sai ruim de verdade) e
ofereça alternativas — instalar Codex ou Gemini, imagem de banco com licença comercial, ou asset do cliente.

## Relação com as outras skills

- **`schematize-observability`** — o que acorda alguém e o runbook que o alerta aponta; o SLI que mede o impacto.
- **`schematize-infra`** — o DR, o failover e o isolamento que tornam a mitigação possível.
- **`schematize-docs`** — runbook e ADR, e o índice onde o postmortem é achado.
- **`schematize-archive`** — o repositório privado onde postmortem e ADR ficam.
- **`schematize-engineering`** — a base: DoD, operação, efeito externo; e `schematize overdev delegar` para as ações do postmortem.
