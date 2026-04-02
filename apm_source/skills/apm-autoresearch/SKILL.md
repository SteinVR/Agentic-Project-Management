---
name: apm-autoresearch
description: "Autonomous experiment loop: agent iterates on code, runs experiments, keeps improvements, discards failures, repeats indefinitely. Use for rapid metric optimization — model training (val_loss, accuracy), performance tuning (latency, throughput), or any measurable objective. Inspired by Karpathy's autoresearch."
---

## What I do
Run an autonomous cycle of rapid experiments against a single target metric. Each iteration: hypothesize → modify code → run → evaluate → keep or discard. No human in the loop until manually interrupted.

Does **not** replace `apm-ds-exp`. That skill is for single, carefully-planned experiments with quality gates and user approval. This skill is for high-volume autonomous iteration.

## Setup (with user)

Agree on these parameters before starting:

1. **Run tag** — propose based on date (e.g. `apr2`). Branch: `autoresearch/<tag>`.
2. **Objective** — metric name + direction (`minimize` or `maximize`).
3. **Runner** — command to execute one experiment (e.g. `uv run train.py`, `python benchmark.py`, `npm run perf-test`).
4. **Metric extraction** — how to read the metric from output. Prefer a grep pattern (e.g. `grep "^val_loss:" run.log`). If the metric is not printed in a greppable format, agree on a parsing approach.
5. **In-scope files** — files you may modify. Everything else is off-limits.
6. **Read-only context** — files to read for understanding but never edit.
7. **Budget** — max wall-clock time per experiment. If a run exceeds 2× budget, kill it and treat as crash. For DL tasks: discuss whether early stopping at budget is informative — if the model needs N epochs to converge and budget cuts training short, the metric may be meaningless. Agree on a budget that produces comparable, interpretable results (e.g. fixed epoch count, fixed token count, or enough wall-clock time for convergence).
8. **Constraints** — hard limits (memory, VRAM, disk, etc.). Soft constraints (minor increase acceptable for meaningful metric gain).

### Setup steps
1. Verify `autoresearch/<tag>` branch does not exist. Create it from current HEAD.
2. Read all in-scope and read-only files for full context.
3. Create `results.tsv` with header row (see Results tracking below).
4. **Baseline run**: execute the runner as-is, without modifications. Record result as baseline in `results.tsv`. This is the starting point for all comparisons.
5. Confirm setup with the user. Once confirmed, begin the experiment loop.

## Experiment loop

**LOOP FOREVER:**

1. Review `results.tsv` and recent git history. Identify patterns: what worked, what failed, what's unexplored.
2. Formulate a hypothesis — what to change and why you expect improvement.
3. Modify in-scope files to implement the idea.
4. `git commit` with a concise message describing the change.
5. Run the experiment: `<runner> > run.log 2>&1`. Redirect everything — do NOT use tee or let output flood your context.
6. Extract the metric from `run.log`.
7. **If extraction fails** (empty output = crash): run `tail -n 50 run.log` for the error. If it's a simple fix (typo, import, off-by-one), fix and re-run. If the idea is fundamentally broken, log as `crash` and move on.
8. Record the result in `results.tsv`.
9. **If metric improved**: keep the commit. Record its short hash as the current `keep_ref` — this is the new baseline for future comparisons.
10. **If metric is equal or worse**: `git reset --hard <keep_ref>` to discard back to the last kept commit. Do not use `HEAD~1` — there may be multiple commits since the last keep (e.g. crash fix attempts).
11. **Deep rewind**: if you feel stuck after multiple iterations (e.g. a `keep` led to a local optimum that blocks further progress), you may rewind past it to an earlier `keep_ref` from `results.tsv`. Do this very sparingly — it discards validated improvements.
12. **REPEAT.** Do not pause. Do not ask the user whether to continue. The user may be away. Run until manually interrupted. If you run out of ideas — re-read in-scope files, re-analyze results history, try combining previous near-misses, try more radical changes. The loop does not stop.

## Simplicity criterion

All else equal, simpler is better.
- Small metric improvement that adds ugly complexity → probably not worth it.
- Removing code and getting equal or better results → always keep. That's a simplification win.
- Near-zero improvement but much simpler code → keep.

Weigh complexity cost against improvement magnitude on every keep/discard decision.

## Results tracking

`results.tsv` — tab-separated, **not committed to git** (leave untracked).

Required columns: `commit`, the primary metric, `status`, `description`. Beyond these, add any secondary metrics that help interpret results — decide based on the task. For DL: peak memory, training time, MFU, total tokens, num params. For dev: p50/p99 latency, throughput, binary size. Use judgment.

Header example (DL task):

```
commit	val_bpb	peak_vram_gb	mfu_pct	status	description
a1b2c3d	0.9979	44.0	39.8	keep	baseline
b2c3d4e	0.9932	44.2	40.1	keep	increase LR to 0.04
c3d4e5f	1.0050	44.0	38.5	discard	switch to GeLU activation
d4e5f6g	0.0000	0.0	0.0	crash	double model width (OOM)
```

Header example (dev task):

```
commit	p99_ms	throughput_rps	status	description
a1b2c3d	142	3200	keep	baseline
b2c3d4e	118	3450	keep	switch to connection pooling
```

- `commit`: short git hash (7 chars)
- `status`: `keep`, `discard`, or `crash`
- `description`: short text — what this experiment tried
- Use `0` / `0.0` for metrics on crashed runs

## Crash handling

Use your judgment. If the crash is something dumb and easy to fix (typo, missing import, shape mismatch, off-by-one) — fix it and re-run the same idea. If the idea itself is fundamentally broken (OOM on a model that's 10× too large, an approach that can't converge) — skip it, log `crash` in the TSV, revert, and move on. Do not waste iterations on a dead end.

If budget is defined and a run exceeds 2× budget — kill the process, treat as crash.

## Guardrails

- Only modify files listed in the in-scope parameter. Everything else is read-only.
- Do not install new dependencies unless explicitly allowed in constraints.
- Do not modify the evaluation/metric extraction mechanism.
- Do not update Memory Bank files during the loop.
- Do not commit `results.tsv` — it stays untracked.
- Do not ask the user whether to continue once the loop has started.
