---
description: schematize-incident — avalia o gatilho de dado pessoal, levanta os fatos e registra a decisão sobre ANPD e titulares
argument-hint: "<o que se sabe sobre os dados envolvidos>"
---

# /inc-lgpd — a pergunta certa na hora certa

Contexto: `${ARGUMENTS}`

1. Leia `references/lgpd.md` e **confira o regulamento vigente** (`references/stack-versoes.md`): isto é ficha técnica,
   a decisão é do controlador com o encarregado e o jurídico.
2. **Gatilho:** houve ou pode ter havido acesso, perda, alteração, divulgação ou destruição indevidos de dado
   pessoal? Sim ou "talvez" -> SEV1, canal restrito, acione o encarregado.
3. **Registre na timeline** a hora em que se soube que havia dado pessoal (o relógio do prazo).
4. Levante: categorias de dado (sensível? crianças?), nº de titulares, natureza (confidencialidade, integridade,
   disponibilidade), cifrado e chave exposta?, contenção, medidas que existiam, quando ocorreu e quando se soube.
5. Escreva a **decisão** no postmortem: `Dados pessoais: sim` e `ANPD: <data da comunicação>` ou
   `ANPD: não comunicar — <justificativa>`. Guarde avaliação e decisão no archive mesmo sem comunicação.
6. Rascunhe a comunicação ao titular (linguagem clara) para revisão humana. Nunca cole o dado vazado em canal aberto,
   no postmortem ou em chat de IA.
