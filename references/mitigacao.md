# Mitigar antes de diagnosticar

> O usuário não paga pela causa raiz; paga pelo serviço. A primeira pergunta é "como paro o
> sangramento?", não "por que quebrou?".

## 1. A ordem

1. **Estancar**: reduzir o impacto agora, mesmo sem entender. Diagnóstico profundo vem depois.
2. **Reverter o último que mudou** antes de teorizar: deploy, feature flag, config, migração,
   certificado, dependência. `git log`/painel de deploy da última hora é o primeiro lugar a olhar.
3. **Confirmar** pelo sinal do usuário (SLI), não pelo "deploy verde": métrica volta ao normal e
   fica por uma janela (10 min em SEV1/2) antes de declarar mitigado.
4. **Só então** diagnosticar com calma, preservando evidência (logs, dumps, estado) antes de reiniciar.

## 2. Alavancas, da mais barata à mais cara

| Alavanca | Quando | Cuidado |
|---|---|---|
| Desligar **feature flag** | Defeito atrelado a funcionalidade nova | A flag tem de existir antes (kill switch por feature de risco) |
| **Rollback** do deploy | Regressão logo após release | Migração destrutiva não volta: expand-contract evita (`schematize-database`) |
| Escalar / reiniciar | Saturação, vazamento de recurso | Reiniciar destrói evidência: capture antes; e só adia |
| **Desviar tráfego** (failover, região, cache stale) | Dependência fora | Teste de DR já feito (`schematize-infra → references/resiliencia.md`) |
| Degradar com graça | Dependência não essencial | Modo degradado precisa estar desenhado, não improvisado |
| Limitar taxa / bloquear origem | Abuso, tempestade de retry | Registrar a regra para remover depois |
| **Drenar / replay de DLQ ou outbox** | Dependência voltou e sobrou backlog (fila cheia, DLQ com mensagens, outbox parado) | Operação nomeada do ops (`ops queue drain`/`replay`, dry-run primeiro), nunca script na mão; só com consumidor **idempotente** (piso 28, testes 3 e 4: restart com fila cheia, reentrega); taxa limitada para não derrubar a dependência recém-recuperada; mensagem envenenada fica na DLQ para análise |
| Rollforward (correção) | Rollback impossível | Só com revisão rápida de 2 pares; é a opção de maior risco. Segue o trilho de hotfix abaixo |

## 2b. Quem executa a mitigação em prd (pisos 23-24 da `schematize-engineering`)

- **A IA não executa mitigação direta na VPS** (sem ssh mutável, sem `systemctl`/`docker`/SQL na
  mão). Ela mitiga **por operação nomeada do ops**: `rollback`, `restart`, flag/kill-switch,
  `health`/`logs` para evidência. Operação destrutiva pede confirmação humana (e decisão do IC).
- Falta a operação? **Implementa-se no repo do ops, via git** — não se contorna por ssh. Rollback é
  para SHA/tag do git; nada de copiar arquivo para o servidor.
- **Break-glass** (acesso direto de emergência) é **humano e auditado**, nunca da IA; o IC o
  autoriza e registra quem/quando/por quê no canal.
- O **postmortem registra todo desvio** (uso de break-glass, ação fora do ops, comando que faltou no
  ops) e abre ação de prevenção: implementar a operação no ops.

## 2c. Hotfix/rollforward: o mesmo trilho, só acelerado (pisos 14, 22, 23 e 27)

- O hotfix segue **dev -> git -> hml -> prd**: entra pelo git (push feito, `HEAD == origin`), o ops puxa e
  confere o SHA; nada de copiar arquivo para a VPS. Rollback também é SHA/tag anterior do git.
- O **CI remoto roda uma vez** (tag `hml-*`, disparado pelo ops), não a cada tentativa; o gate local por
  commit roda antes. Não há "CI verde no PR" a esperar.
- Pular hml (se a casa tem hml) é **decisão do IC**, registrada no canal com motivo e risco; sem hml no
  projeto, o gate local + o plano de rollback valem. Pular o git nunca é opção.

## 2d. Backlog (fila, DLQ, outbox): critério de "mitigado"

Impacto parado não basta quando há trabalho represado. **Mitigado** = (1) a causa do represamento cessou
(dependência de volta, consumidor saudável), (2) a **profundidade e a idade da mensagem mais antiga**
estão caindo de forma sustentada e o ETA de drenagem foi estimado, (3) a taxa de erro/DLQ voltou ao
normal e (4) não há duplicata nem perda (reentrega idempotente conferida por amostra/contagem). Só é
**resolvido** com o backlog em zero, a DLQ triada (reprocessada ou descartada com decisão registrada) e a
prova do dado: **entrou N, saiu N**. O postmortem responde "dado perdido? sim/não + prova".

## 3. Proibido na mitigação

- Ação destrutiva e irreversível (apagar dado, `DROP`, `terraform destroy`, force-push) sem decisão
  explícita do IC registrada. Em prd, o plano de rollback vem **antes** da ação.
- Mitigação da IA por ssh/script próprio na VPS (ver 2b): vetado; só via ops.
- Mexer sem narrar: toda ação no canal antes de executar ("vou reverter X, ok?").
- "Corrigir" mudando várias coisas ao mesmo tempo: uma alavanca por vez, senão não se sabe o que funcionou.
- Disparar efeito externo de verdade para "testar" a correção (e-mail, cobrança, webhook): use o
  sandbox/sink da casa.

## 4. Declarar o fim

Mitigado != resolvido. **Mitigado**: impacto parou. **Resolvido**: causa tratada ou contornada de
forma estável, alertas limpos, status page encerrada, postmortem agendado (SEV1/2: em até 5 dias úteis).

Spam em massa por bot ou token de bot vazado: desligue o bot e revogue o token primeiro; ver `schematize-bots → references/ambientes-e-efeito-externo.md`.
