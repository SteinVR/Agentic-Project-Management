"""
Main Modeling Pipeline Script.

This script contains the complete ML pipeline organized in cell-like blocks.
Use `# %% [Block Name]` separators for block-by-block execution.

Run blocks individually using IDE's "Run Cell" feature (Ctrl+Enter in VS Code/Cursor).

Note: EDA is performed separately in eda/eda.py
"""

# %% [Setup] ===================================================================
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

from config import *
from src.data import load_data, save_data, split_data
from src.features import create_features
from src.models import train_model, save_model, get_feature_importance
from src.evaluation import evaluate_model, cross_validate

# Set random seed for reproducibility
np.random.seed(RANDOM_SEED)

print(f"Project: {PROJECT_ROOT.name}")
print(f"Random Seed: {RANDOM_SEED}")

# %% [Load Data] ===============================================================


# %% [Preprocessing] ===========================================================


# %% [Split Data] ==============================================================


# %% [Prepare Features] ========================================================


# %% [Baseline Model] ==========================================================


# %% [Evaluate Baseline] =======================================================


# %% [Cross-Validation] ========================================================


# %% [Feature Importance] ======================================================


# %% [Save Baseline Model] =====================================================


# %% [Final Test Evaluation] ===================================================

