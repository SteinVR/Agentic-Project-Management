"""
Model training and inference functions.

This module contains functions for model initialization, training, and prediction.
"""

import numpy as np
import pandas as pd
from typing import Any
from pathlib import Path


def train_model(
    X: np.ndarray | pd.DataFrame,
    y: np.ndarray | pd.Series,
    model_type: str = "random_forest",
    params: dict | None = None,
    random_state: int = 42
) -> Any:
    """
    Train a model with given configuration.
    
    Args:
        X: Feature matrix
        y: Target vector
        model_type: Type of model to train
        params: Model hyperparameters
        random_state: Random seed for reproducibility
        
    Returns:
        Trained model
    """
    params = params or {}
    
    if model_type == "random_forest":
        from sklearn.ensemble import RandomForestClassifier
        model = RandomForestClassifier(random_state=random_state, **params)
    elif model_type == "xgboost":
        from xgboost import XGBClassifier
        model = XGBClassifier(random_state=random_state, **params)
    elif model_type == "lightgbm":
        from lightgbm import LGBMClassifier
        model = LGBMClassifier(random_state=random_state, **params)
    elif model_type == "logistic":
        from sklearn.linear_model import LogisticRegression
        model = LogisticRegression(random_state=random_state, **params)
    else:
        raise ValueError(f"Unknown model type: {model_type}")
    
    model.fit(X, y)
    return model


def predict(model: Any, X: np.ndarray | pd.DataFrame) -> np.ndarray:
    """
    Make predictions with trained model.
    
    Args:
        model: Trained model
        X: Feature matrix
        
    Returns:
        Predictions
    """
    return model.predict(X)


def predict_proba(model: Any, X: np.ndarray | pd.DataFrame) -> np.ndarray:
    """
    Get prediction probabilities.
    
    Args:
        model: Trained model
        X: Feature matrix
        
    Returns:
        Prediction probabilities
    """
    return model.predict_proba(X)


def save_model(model: Any, path: str | Path, metadata: dict | None = None) -> None:
    """
    Save model to disk with optional metadata.
    
    Args:
        model: Model to save
        path: Output path
        metadata: Optional metadata to save alongside model
    """
    import joblib
    
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    
    joblib.dump(model, path)
    
    if metadata:
        import json
        meta_path = path.with_suffix(".json")
        with open(meta_path, "w") as f:
            json.dump(metadata, f, indent=2)


def load_model(path: str | Path) -> Any:
    """
    Load model from disk.
    
    Args:
        path: Path to model file
        
    Returns:
        Loaded model
    """
    import joblib
    return joblib.load(path)


def get_feature_importance(
    model: Any,
    feature_names: list[str]
) -> pd.DataFrame:
    """
    Extract feature importance from model.
    
    Args:
        model: Trained model
        feature_names: List of feature names
        
    Returns:
        DataFrame with feature importances
    """
    if hasattr(model, "feature_importances_"):
        importances = model.feature_importances_
    elif hasattr(model, "coef_"):
        importances = np.abs(model.coef_).flatten()
    else:
        raise ValueError("Model does not have feature importance attribute")
    
    importance_df = pd.DataFrame({
        "feature": feature_names,
        "importance": importances
    }).sort_values("importance", ascending=False)
    
    return importance_df
