# DS Logging Template (Example)

**Logs directory:** `logs/`
**Format:** `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`

## Minimum content
- Dataset version or snapshot date
- Split strategy and random seed
- Model type and key hyperparameters
- Metrics per epoch/iteration
- Artifact paths and runtime duration

## Example log lines
```
[2026-01-30 10:14:05] [INFO] - Dataset=churn_v1, seed=42
[2026-01-30 10:14:06] [INFO] - Split=70/15/15 stratified
[2026-01-30 10:14:08] [INFO] - Model=XGBoost params={"max_depth":6,"eta":0.1}
[2026-01-30 10:14:10] [INFO] - Epoch=1 loss=0.431 f1=0.71 auc=0.86
[2026-01-30 10:14:22] [INFO] - Epoch=2 loss=0.392 f1=0.74 auc=0.88
[2026-01-30 10:14:50] [INFO] - Saved model=models/model_exp003_f1_0.74.pkl
[2026-01-30 10:14:52] [INFO] - Run complete duration=47s
```

## Checklist
- [ ] Log data version and seed
- [ ] Log model config and metrics
- [ ] Log artifacts and runtime
- [ ] Record errors with stack context

