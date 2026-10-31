# Papéis, canal e timeline

> Incidente sem comando vira reunião de 12 pessoas debugando a mesma coisa. Um papel por pessoa,
> um canal, uma timeline.

## 1. Papéis

| Papel | Faz | Não faz |
|---|---|---|
| **IC** (comandante) | Decide, delega, mantém o ritmo (a cada 15 min: "estado, hipótese, próximo passo"), reclassifica SEV, chama gente, declara o fim | Não mexe no sistema; não faz debug |
| **Ops** (operador) | Executa mitigação e diagnóstico; narra o que faz antes de fazer | Não decide sozinho ação destrutiva (pede ao IC) |
| **Comms** | Fala com status page, cliente, suporte, direção, no ritmo combinado | Não especula causa |
| **Escriba** | Mantém a timeline com hora, quem, o quê, fonte | Não participa do debug |

- Em incidente pequeno uma pessoa acumula Ops+Escriba; **IC e Ops nunca são a mesma pessoa em SEV1/2**.
- **Passagem de comando é explícita** ("@ana, você é o IC"), com resumo de 30 s. Turno de IC: até 2 h em SEV1.
- Quem declarou o incidente é IC até passar o comando. Qualquer pessoa pode declarar; ninguém é
  punido por declarar alarme falso (isso é o que mantém o alarme honesto).

## 2. Canal e ponte

- Um canal por incidente: `#inc-AAAA-NNN` (e uma chamada de voz fixada). Tópico: severidade, IC,
  link da status page, próxima atualização.
- Fala técnica no canal; **decisão** com prefixo `DECISÃO:` (o escriba copia para a timeline).
- Segurança/dado pessoal: canal **restrito**, e o que entra nele é minimizado (nada de PII colada).

## 3. Timeline

- UTC, formato `HH:MM`, um fato por linha, com fonte (link de gráfico, comando, commit). O escriba
  registra: início do impacto, detecção, declaração, cada hipótese descartada, cada ação (e o
  resultado), mitigação, resolução. `assets/templates/timeline.md` é o molde.
- A timeline viva vira a seção "Timeline" do postmortem sem reescrita pesada.
- Diferencie **início do impacto** (do gráfico) de **detecção** (do alerta): a diferença é o TTD, e
  é o número que mais ensina.
