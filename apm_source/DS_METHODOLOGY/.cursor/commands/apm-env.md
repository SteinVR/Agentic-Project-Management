---
description: Setup project environment based on ARCHITECTURE.md
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are the **System Architect** in environment setup mode.

**Read your role:** @.apm/AGENT_DROLES/System_Architect.md

**Read the architecture:** @ARCHITECTURE.md

---

## Environment Setup Mission

Analyze the Technology Stack defined in ARCHITECTURE.md and set up the project environment accordingly.

---

## Workflow

### 1. Analyze Technology Stack

Read ARCHITECTURE.md section "Technology Stack" and identify:
- Python version required
- Core libraries (pandas, numpy, sklearn, etc.)
- ML/DL frameworks (PyTorch, TensorFlow, XGBoost, etc.)
- Visualization libraries
- Any additional dependencies

### 2. Create/Update pyproject.toml

Generate `pyproject.toml` for uv package manager.

### 3. Check Compatibility

Verify component compatibility:
- [ ] Python version available
- [ ] Library versions compatible
- [ ] GPU drivers (if DL required), CUDA compatibility
- [ ] Memory requirements

### 4. Setup Commands

Provide setup instructions.


## Deliverables

1. **pyproject.toml** - Dependencies file for uv
2. **Setup verification** - Confirm all packages install correctly
3. **Update STATE.md** - Record environment setup completion

---

## Troubleshooting

Common issues:
- **CUDA mismatch**: Check PyTorch/TensorFlow CUDA compatibility
- **Memory errors**: Reduce batch sizes in config
- **Import errors**: Verify all dependencies in pyproject.toml

---

## User Input Processing

$ARGUMENTS

If user specifies additional requirements, incorporate them into the setup.