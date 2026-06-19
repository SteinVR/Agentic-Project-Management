# Baseline Experiment Guide

A baseline is the first experiment in a project. It establishes a domain-credible reference benchmark for all subsequent comparisons.

## What makes a good baseline
- Not complex or overengineered but strong enough to compare against, not a toy model.
- A model class that could plausibly remain in the final pipeline.
- Fixed, explicit hyperparameters (no tuning at baseline stage).
- Reproducible and comparable across future experiments.


## Baseline-specific post-run analysis
After the full run, the baseline analysis should additionally cover:
- What the baseline reveals about the problem structure.
- Which directions are promising for experiments and which are likely dead ends.
- Initial hypotheses for the experiment phase, grounded in baseline behavior.
