## Expected structure
- `tests/` is a compact smoke suite (target 1 test per module/microservice).
- Keep one smoke test per core stage.

## Conventions
- Assert factual outputs: stage artifacts, grounded page references, typed answers, and manifest integrity.
- Do not anchor tests to private helper internals when a stage-level observable can be validated instead.
- OpenAI/API-backed generation calls are not allowed in tests; provider paths must use deterministic local stubs.
- Model-backed smoke checks are GPU-only: no CPU fallback, no auto-downgrade. Missing CUDA/model readiness must fail fast.
- Name test files to mirror source: `test_{module}.py` or `{module}.test.ts`.

## Guardrails
- Do not silently skip required model/runtime smoke checks due to missing GPU or model cache; fail with explicit diagnostics.
