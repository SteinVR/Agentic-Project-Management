"""
Model evaluation and metrics functions.

This module contains functions for computing metrics and analyzing model performance.
"""

import numpy as np
import pandas as pd
from typing import Any


def evaluate_model(
    model: Any,
    X: np.ndarray | pd.DataFrame,
    y: np.ndarray | pd.Series,
    task: str = "classification"
) -> dict:
    """
    Evaluate model on given data.
    
    Args:
        model: Trained model
        X: Feature matrix
        y: True labels
        task: Task type ("classification" or "regression")
        
    Returns:
        Dictionary with evaluation metrics
    """
    y_pred = model.predict(X)
    
    if task == "classification":
        return evaluate_classification(y, y_pred, model, X)
    elif task == "regression":
        return evaluate_regression(y, y_pred)
    else:
        raise ValueError(f"Unknown task: {task}")


def evaluate_classification(
    y_true: np.ndarray,
    y_pred: np.ndarray,
    model: Any | None = None,
    X: np.ndarray | None = None
) -> dict:
    """
    Compute classification metrics.
    
    Args:
        y_true: True labels
        y_pred: Predicted labels
        model: Optional model for probability-based metrics
        X: Optional features for probability-based metrics
        
    Returns:
        Dictionary with classification metrics
    """
    from sklearn.metrics import (
        accuracy_score,
        precision_score,
        recall_score,
        f1_score,
        roc_auc_score,
        confusion_matrix
    )
    
    metrics = {
        "accuracy": accuracy_score(y_true, y_pred),
        "precision": precision_score(y_true, y_pred, average="weighted", zero_division=0),
        "recall": recall_score(y_true, y_pred, average="weighted", zero_division=0),
        "f1": f1_score(y_true, y_pred, average="weighted", zero_division=0),
    }
    
    # Add AUC if model can predict probabilities
    if model is not None and X is not None and hasattr(model, "predict_proba"):
        try:
            y_proba = model.predict_proba(X)
            if y_proba.shape[1] == 2:
                metrics["auc"] = roc_auc_score(y_true, y_proba[:, 1])
            else:
                metrics["auc"] = roc_auc_score(y_true, y_proba, multi_class="ovr", average="weighted")
        except Exception:
            pass
    
    # Confusion matrix
    cm = confusion_matrix(y_true, y_pred)
    metrics["confusion_matrix"] = cm.tolist()
    
    return metrics


def evaluate_regression(y_true: np.ndarray, y_pred: np.ndarray) -> dict:
    """
    Compute regression metrics.
    
    Args:
        y_true: True values
        y_pred: Predicted values
        
    Returns:
        Dictionary with regression metrics
    """
    from sklearn.metrics import (
        mean_absolute_error,
        mean_squared_error,
        r2_score,
        mean_absolute_percentage_error
    )
    
    return {
        "mae": mean_absolute_error(y_true, y_pred),
        "mse": mean_squared_error(y_true, y_pred),
        "rmse": np.sqrt(mean_squared_error(y_true, y_pred)),
        "r2": r2_score(y_true, y_pred),
        "mape": mean_absolute_percentage_error(y_true, y_pred) * 100
    }


def cross_validate(
    model: Any,
    X: np.ndarray | pd.DataFrame,
    y: np.ndarray | pd.Series,
    cv: int = 5,
    scoring: str | list[str] = "f1_weighted"
) -> dict:
    """
    Perform cross-validation.
    
    Args:
        model: Model to evaluate
        X: Feature matrix
        y: Target vector
        cv: Number of folds
        scoring: Scoring metric(s)
        
    Returns:
        Cross-validation results
    """
    from sklearn.model_selection import cross_validate as sklearn_cv
    
    if isinstance(scoring, str):
        scoring = [scoring]
    
    cv_results = sklearn_cv(
        model, X, y,
        cv=cv,
        scoring=scoring,
        return_train_score=True
    )
    
    results = {}
    for score_name in scoring:
        test_key = f"test_{score_name}"
        train_key = f"train_{score_name}"
        
        results[score_name] = {
            "mean": cv_results[test_key].mean(),
            "std": cv_results[test_key].std(),
            "train_mean": cv_results[train_key].mean(),
            "train_std": cv_results[train_key].std(),
            "folds": cv_results[test_key].tolist()
        }
    
    return results


def compare_with_baseline(
    current_metrics: dict,
    baseline_metrics: dict
) -> dict:
    """
    Compare current metrics with baseline.
    
    Args:
        current_metrics: Current experiment metrics
        baseline_metrics: Baseline metrics
        
    Returns:
        Comparison results with deltas
    """
    comparison = {}
    
    for key in current_metrics:
        if key in baseline_metrics and isinstance(current_metrics[key], (int, float)):
            baseline_val = baseline_metrics[key]
            current_val = current_metrics[key]
            delta = current_val - baseline_val
            delta_pct = (delta / baseline_val * 100) if baseline_val != 0 else 0
            
            comparison[key] = {
                "baseline": baseline_val,
                "current": current_val,
                "delta": delta,
                "delta_pct": delta_pct,
                "improved": delta > 0
            }
    
    return comparison
