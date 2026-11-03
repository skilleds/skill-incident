# Incidente com dado pessoal: LGPD e ANPD

> Ficha técnica, não parecer jurídico. A decisão de comunicar é do controlador com o encarregado
> (DPO) e o jurídico; a skill garante que a pergunta é feita **na hora certa** e que o relógio é
> conhecido. Fatos e prazos verificados em `references/stack-versoes.md`.

## 1. Gatilho

Houve (ou pode ter havido) acesso, perda, alteração, divulgação ou destruição **indevidos** de dado
pessoal? Se sim ou "talvez": **SEV1 até provar o contrário**, canal restrito, encarregado acionado.

## 2. O relógio (verificar o regulamento vigente)

- Base legal: LGPD art. 48 (comunicação à ANPD e ao titular quando o incidente puder acarretar risco ou dano relevante).
- Regulamento: Resolução CD/ANPD nº 15/2024. Prazo de comunicação: **3 dias úteis** contados do
  **conhecimento** de que o incidente envolve dado pessoal com risco relevante; complementação posterior
  permitida (ver anexo). Prazo diferente para agente de pequeno porte: `<!-- reverificar -->`.
- **Quem é o controlador?** Se você é operador, avisa o controlador sem demora (contrato define o prazo, em geral menor).
- O relógio **começa na timeline**: registre a hora em que se soube que havia dado pessoal.

## 3. O que levantar nas primeiras horas

| Pergunta | Por quê |
|---|---|
| Quais dados (categorias, sensíveis? crianças?) e quantos titulares | Mede risco e define a comunicação |
| Confidencialidade, integridade ou disponibilidade | Natureza do incidente |
| Dado estava cifrado/pseudonimizado e a chave foi exposta? | Muda o risco |
| Há contenção e qual o estado atual | Parte do comunicado |
| Medidas de segurança que existiam | Parte do comunicado |
| Quando ocorreu, quando se soube | Prazo e transparência |

## 4. Decisão e registro

1. Encarregado + jurídico decidem: comunicar ANPD, titulares, ambos, ou **não comunicar com justificativa
   escrita** (ausência de risco relevante).
2. A decisão vai no postmortem: linha `Dados pessoais: sim` e linha `ANPD: <data da comunicação>` ou
   `ANPD: não comunicar — <justificativa>` (o `scripts/check-postmortem.sh` exige).
3. **Registro do incidente** é obrigação mesmo quando não há comunicação: guarde avaliação e decisão no archive.
4. Comunicação ao titular: linguagem clara, o que houve, que dado, o que fazemos, o que o titular pode fazer, contato do encarregado.
5. **Não coloque o dado vazado** no postmortem, no canal aberto ou no chat de IA.

Quando houver tema de segurança ofensivo associado (como foi explorado), o teste vai para
`schematize-pentest`; o desenho de identidade para `schematize-iam`.
