# Piso de resposta a incidente (schematize-incident) — sempre-on

Incidente é certo; caos e repetição são escolha. Comande, mitigue, comunique, aprenda, e feche a porta.

1. **Severidade por critério objetivo** (SEV1-4, `references/severidade.md`); na dúvida, suba um nível. Dado pessoal exposto é SEV1 até provar o contrário.
2. **Um IC, um canal, uma timeline** (UTC, um fato por linha). IC não mexe no sistema em SEV1/2; passagem de comando explícita.
3. **Mitigar antes de diagnosticar:** reverter o último que mudou, uma alavanca por vez, tudo narrado. **Ação destrutiva e irreversível só com decisão registrada do IC.**
4. **Silêncio é falha:** primeira nota e cadência por SEV, sempre com a hora da próxima atualização; status page fora da infra afetada; sem causa especulativa nem nome de pessoa.
5. **Dado pessoal:** registre a hora em que se soube, acione o encarregado, decida e escreva a comunicação à ANPD/titulares (ou a justificativa de não comunicar). Verifique o regulamento vigente.
6. **Postmortem blameless** em SEV1/2: timeline, impacto quantificado, porquês e fatores contribuintes, sem "erro humano". Mora em `<projeto>/<projeto>_archive/`.
7. **Action item = dono + prazo**, de preferência de máquina. Incidente recorrente vira **ADR + piso + gate**.
8. Aviso em massa ao cliente é efeito externo: sink fora de prd, cap e revisão em prd.
9. <!-- herdado:engineering/orquestracao:curto -->**Orquestrador não desenvolve; subagent barato executa.** O agent principal só planeja, despacha e revisa; ação onerosa vira micro-tasks para o executor mais barato que resolve: `haiku` (mecânico) / `sonnet` (código; falhou → mesmo subagent corrige, até 2 rodadas) → Codex `gpt-5.6-terra` → Cursor → subagent `opus` (motivo) → `park`; **visual vai direto ao Codex**; **imagem nunca pelo Claude: detectar Codex/Gemini e perguntar ao usuário qual usar (Codex é a sugestão), nunca API de imagem paga**; papéis em `agentes.toml`. No overdev, cada item do checklist vai a um subagent e o principal revisa antes do `- [x]`. **Sem frota ociosa:** idle com pendência volta ao trabalho; dependente de outro agent → mata e enfileira com gatilho; terminou → mata (§9.6). Detalhe: `schematize-engineering` → `references/orquestracao.md` §9.<!-- /herdado -->

<!-- herdado:engineering/pisos-22-29:bloco -->**Herda os pisos 22–29 da `schematize-engineering`** (texto completo em `assets/CLAUDE.md` dela): 22 tudo no git — sem remote, push falho ou HEAD≠origin a demanda NÃO se conclui; 23 deploy só do git (VETADO scp/rsync/tar|ssh/docker save|load/git bundle); 24 o ops é o gate da IA — a IA nunca muda a VPS direto nem escreve SQL, só operação nomeada (`ssh vps "ops <op>"`); 25 sem agents inúteis (entregou, morreu); 26 relatório a cada 30 min e handoff a cada 6 h; 27 CI remoto só antes do hml, a pedido ou em tag (`workflow_dispatch` + `hml-*`/`v*`; VETADO `pull_request`, `push` em branch, `workflow_run`, cron sem justificativa); 28 microserviço autônomo (fila durável + 7 testes de resiliência); 29 build/teste na máquina dev/hml quando existe (ponte só no workspace de build, nunca prd) + higiene (`scripts/higiene.sh`).<!-- /herdado -->

Mídia: imagem/visual gerado nunca por modelo Claude; detecte Codex/Gemini e pergunte qual usar.

Gate: `bash .claude/skills/schematize-incident/scripts/check-postmortem.sh <pasta>` — waiver rastreável
`<!-- inc-ok: <regra> — <motivo> -->`.
