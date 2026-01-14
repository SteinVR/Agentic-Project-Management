"""
Visualization functions.

This module contains functions for creating plots and visual reports.
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path
from typing import Any


def plot_confusion_matrix(
    cm: np.ndarray | list,
    class_names: list[str] | None = None,
    save_path: str | Path | None = None,
    title: str = "Confusion Matrix"
) -> None:
    """
    Plot confusion matrix heatmap.
    
    Args:
        cm: Confusion matrix
        class_names: Names of classes
        save_path: Optional path to save figure
        title: Plot title
    """
    cm = np.array(cm)
    
    if class_names is None:
        class_names = [str(i) for i in range(len(cm))]
    
    plt.figure(figsize=(8, 6))
    sns.heatmap(
        cm,
        annot=True,
        fmt="d",
        cmap="Blues",
        xticklabels=class_names,
        yticklabels=class_names
    )
    plt.title(title)
    plt.ylabel("True Label")
    plt.xlabel("Predicted Label")
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches="tight")
    plt.show()


def plot_feature_importance(
    importance_df: pd.DataFrame,
    top_n: int = 20,
    save_path: str | Path | None = None,
    title: str = "Feature Importance"
) -> None:
    """
    Plot feature importance bar chart.
    
    Args:
        importance_df: DataFrame with 'feature' and 'importance' columns
        top_n: Number of top features to show
        save_path: Optional path to save figure
        title: Plot title
    """
    df = importance_df.head(top_n)
    
    plt.figure(figsize=(10, max(6, len(df) * 0.3)))
    plt.barh(df["feature"], df["importance"])
    plt.xlabel("Importance")
    plt.title(title)
    plt.gca().invert_yaxis()
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches="tight")
    plt.show()


def plot_learning_curves(
    train_scores: list[float],
    val_scores: list[float],
    metric_name: str = "Loss",
    save_path: str | Path | None = None
) -> None:
    """
    Plot training and validation learning curves.
    
    Args:
        train_scores: Training scores per epoch
        val_scores: Validation scores per epoch
        metric_name: Name of the metric
        save_path: Optional path to save figure
    """
    epochs = range(1, len(train_scores) + 1)
    
    plt.figure(figsize=(10, 6))
    plt.plot(epochs, train_scores, "b-", label=f"Training {metric_name}")
    plt.plot(epochs, val_scores, "r-", label=f"Validation {metric_name}")
    plt.xlabel("Epoch")
    plt.ylabel(metric_name)
    plt.title(f"Learning Curves - {metric_name}")
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches="tight")
    plt.show()


def plot_roc_curve(
    y_true: np.ndarray,
    y_proba: np.ndarray,
    save_path: str | Path | None = None
) -> None:
    """
    Plot ROC curve.
    
    Args:
        y_true: True labels
        y_proba: Predicted probabilities for positive class
        save_path: Optional path to save figure
    """
    from sklearn.metrics import roc_curve, auc
    
    fpr, tpr, _ = roc_curve(y_true, y_proba)
    roc_auc = auc(fpr, tpr)
    
    plt.figure(figsize=(8, 6))
    plt.plot(fpr, tpr, color="darkorange", lw=2, label=f"ROC curve (AUC = {roc_auc:.3f})")
    plt.plot([0, 1], [0, 1], color="navy", lw=2, linestyle="--", label="Random")
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel("False Positive Rate")
    plt.ylabel("True Positive Rate")
    plt.title("Receiver Operating Characteristic (ROC)")
    plt.legend(loc="lower right")
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches="tight")
    plt.show()


def plot_metrics_comparison(
    metrics_dict: dict[str, dict],
    metric_names: list[str] | None = None,
    save_path: str | Path | None = None,
    title: str = "Metrics Comparison"
) -> None:
    """
    Plot comparison of metrics across experiments.
    
    Args:
        metrics_dict: Dict mapping experiment names to their metrics
        metric_names: List of metrics to compare
        save_path: Optional path to save figure
        title: Plot title
    """
    experiments = list(metrics_dict.keys())
    
    if metric_names is None:
        metric_names = list(metrics_dict[experiments[0]].keys())
        metric_names = [m for m in metric_names if isinstance(metrics_dict[experiments[0]][m], (int, float))]
    
    x = np.arange(len(metric_names))
    width = 0.8 / len(experiments)
    
    fig, ax = plt.subplots(figsize=(12, 6))
    
    for i, exp_name in enumerate(experiments):
        values = [metrics_dict[exp_name].get(m, 0) for m in metric_names]
        offset = width * i - width * len(experiments) / 2 + width / 2
        ax.bar(x + offset, values, width, label=exp_name)
    
    ax.set_ylabel("Value")
    ax.set_title(title)
    ax.set_xticks(x)
    ax.set_xticklabels(metric_names, rotation=45, ha="right")
    ax.legend()
    ax.grid(True, alpha=0.3, axis="y")
    
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches="tight")
    plt.show()
