# Incidente recorrente vira ADR + piso + gate

> Regra da casa, nascida do incidente dos 5.000 e-mails (2026-08): atenção humana já era o regime
> vigente e falhou. Se um incidente volta, ou tem cara de que vai, o defeito é **de default** e
> o conselho não resolve.

## 1. Gatilho

É recorrente quando: mesma classe de causa em dois incidentes; ou um quase-incidente que o gate/alerta
só pegou por sorte; ou um postmortem cuja ação é "ter mais cuidado". Declare a recorrência na seção
"Recorrência" do postmortem.

## 2. O fecho, em três peças (todas, ou não fechou)

1. **ADR** em `<projeto>/<projeto>_archive/decisoes/ADR-NNNN-<slug>.md`: contexto (o incidente), decisão (o piso
   novo), consequências. Formato: `schematize-docs → references/adr.md`.
2. **Piso** nas skills/normas do projeto: regra vetada, escrita como proibição ("X nunca Y"), não como recomendação.
3. **Gate determinístico** no CI que reprova a violação (script `check-*.sh` com teste vermelho plantado).
   Piso sem gate de máquina volta a ser atenção humana.

Mais: o teste que reproduz o incidente entra na suíte (regressão) — visto VERMELHO antes do fix, com
o commit culpado localizado por `git bisect` quando a causa não é óbvia (`schematize-regression` →
`references/incidente-e-metricas.md`, `references/bisect.md`) —, e o alerta que o detectaria entra no
código (`schematize-observability → references/slo-alertas.md`).

## 3. Anti-padrões

- "Vamos nos atentar" / treinamento como única ação.
- Gate que só avisa (warning) sobre algo que já derrubou produção.
- ADR sem gate; gate sem ADR (ninguém sabe por que existe e alguém o remove).
- Fechar o incidente com a mitigação, sem a ação de prevenção.
