# Severidade: critério objetivo, não opinião

> Severidade é decidida em 60 segundos por quem está de plantão, com a tabela abaixo. Na dúvida
> entre dois níveis, **sobe um**: é mais barato desescalar que descobrir tarde.

## 1. A tabela

| SEV | Critério (qualquer um basta) | Resposta | Comunicação externa |
|---|---|---|---|
| **SEV1** | Indisponibilidade total ou do fluxo de receita; perda ou vazamento de dado; dado pessoal exposto; segurança comprometida; error budget mensal inteiro consumido em < 1 h | Acorda todos, IC imediato, 24x7 até mitigar | Status page em até 15 min; cliente afetado avisado ativamente |
| **SEV2** | Funcionalidade central degradada para > 10% dos usuários ou para um cliente estratégico; burn-rate rápido (14,4x, janela de 1 h) sem fim à vista | Plantão + IC, horário estendido | Status page em até 30 min |
| **SEV3** | Funcionalidade secundária degradada, contorno existe, < 10% dos usuários; burn-rate lento (6x, 6 h) | Horário comercial, dono do serviço | Status page opcional; nota para o suporte |
| **SEV4** | Defeito cosmético ou sem impacto mensurável ao usuário; risco latente achado antes de doer | Backlog com prazo | Nenhuma |

Os limiares de burn-rate acompanham `schematize-observability → references/slo-alertas.md`
(a SLO e o alerta moram lá; aqui só se **usa** o sinal para classificar).

## 2. Regras de classificação

1. **Dado pessoal exposto é SEV1 até prova em contrário**, e dispara `references/lgpd.md` em paralelo.
2. **Segurança** (credencial vazada, acesso indevido) é no mínimo SEV2 e vai para o canal de segurança
   restrito, não para o canal aberto. Segredo commitado: rode `/git-leak` (`schematize-git`) em
   paralelo: rotacionar primeiro, medir, limpar o código, só então decidir sobre o histórico.
3. **Reclassifique em voz alta** no canal (`SEV2 -> SEV1, motivo`). A timeline registra cada mudança.
4. Severidade mede **impacto**, não esforço nem culpa: bug trivial que derruba pagamentos é SEV1.
5. Efeito externo indevido (e-mail em massa, cobrança, webhook de terceiro disparado de verdade) é
   no mínimo SEV2 mesmo sem indisponibilidade (reputação e custo não têm undo).
6. Sem critério objetivo na hora: **SEV2 e refina em 15 min**.
