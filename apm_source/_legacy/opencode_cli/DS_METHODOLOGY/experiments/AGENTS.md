# DS -- Experiments

## Skill
- Use **apm-ds-exp** for hypothesis-driven experiments.

## Expected structure
Each experiment lives in its own directory:
```
experiments/EXP-XXX_{description}/
  main_exp.py      # Experiment pipeline (cell-like blocks)
  config.py        # Experiment-specific hyperparameters
  REPORT.md        # Experiment report (from apm-ds-exp template)
```

## Conventions
- Number experiments sequentially: `EXP-001`, `EXP-002`, etc.
- Always set and log random seeds for reproducibility.
- Update `memory-bank/TASK.md` (mark hypothesis tested, update Active Experiment) and `memory-bank/STATE.md` (experiment history) after runs.

## Guardrails
- Do not run full training without user approval; smoke-test first.
- Keep experiment code self-contained; shared logic belongs in `src/`.
