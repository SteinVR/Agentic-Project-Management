"""
Exploratory Data Analysis functions.

This module contains functions for data exploration and visualization.
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path


def describe_dataset(df: pd.DataFrame) -> dict:
    """
    Get comprehensive dataset statistics.
    
    Args:
        df: Input DataFrame
        
    Returns:
        Dictionary with dataset statistics
    """
    stats = {
        "n_rows": len(df),
        "n_cols": len(df.columns),
        "memory_mb": df.memory_usage(deep=True).sum() / 1024 / 1024,
        "missing_pct": (df.isnull().sum().sum() / df.size) * 100,
        "duplicates": df.duplicated().sum(),
        "dtypes": df.dtypes.value_counts().to_dict(),
    }
    return stats


def analyze_missing(df: pd.DataFrame) -> pd.DataFrame:
    """
    Analyze missing value patterns.
    
    Args:
        df: Input DataFrame
        
    Returns:
        DataFrame with missing value statistics per column
    """
    missing = pd.DataFrame({
        "missing_count": df.isnull().sum(),
        "missing_pct": (df.isnull().sum() / len(df)) * 100,
        "dtype": df.dtypes
    })
    return missing[missing["missing_count"] > 0].sort_values("missing_pct", ascending=False)


def analyze_target(df: pd.DataFrame, target_col: str) -> dict:
    """
    Analyze target variable distribution.
    
    Args:
        df: Input DataFrame
        target_col: Name of target column
        
    Returns:
        Dictionary with target statistics
    """
    target = df[target_col]
    
    if target.dtype in ["object", "category"] or target.nunique() < 20:
        # Classification target
        value_counts = target.value_counts()
        return {
            "type": "classification",
            "n_classes": target.nunique(),
            "class_distribution": value_counts.to_dict(),
            "class_balance": (value_counts / len(target) * 100).to_dict(),
            "imbalance_ratio": value_counts.max() / value_counts.min()
        }
    else:
        # Regression target
        return {
            "type": "regression",
            "mean": target.mean(),
            "std": target.std(),
            "min": target.min(),
            "max": target.max(),
            "median": target.median(),
            "skewness": target.skew()
        }


def plot_distributions(
    df: pd.DataFrame, 
    cols: list[str] | None = None,
    save_path: str | Path | None = None
) -> None:
    """
    Plot distributions for numerical columns.
    
    Args:
        df: Input DataFrame
        cols: List of columns to plot (defaults to all numerical)
        save_path: Optional path to save figure
    """
    if cols is None:
        cols = df.select_dtypes(include=[np.number]).columns.tolist()
    
    n_cols = min(3, len(cols))
    n_rows = (len(cols) + n_cols - 1) // n_cols
    
    fig, axes = plt.subplots(n_rows, n_cols, figsize=(5 * n_cols, 4 * n_rows))
    axes = np.atleast_2d(axes).flatten()
    
    for i, col in enumerate(cols):
        axes[i].hist(df[col].dropna(), bins=50, edgecolor="black", alpha=0.7)
        axes[i].set_title(f"{col}")
        axes[i].set_xlabel(col)
    
    for j in range(i + 1, len(axes)):
        axes[j].set_visible(False)
    
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches="tight")
    plt.show()


def plot_correlations(
    df: pd.DataFrame,
    method: str = "pearson",
    save_path: str | Path | None = None
) -> None:
    """
    Plot correlation heatmap.
    
    Args:
        df: Input DataFrame
        method: Correlation method ("pearson", "spearman", "kendall")
        save_path: Optional path to save figure
    """
    numerical_cols = df.select_dtypes(include=[np.number]).columns
    corr = df[numerical_cols].corr(method=method)
    
    plt.figure(figsize=(12, 10))
    sns.heatmap(
        corr,
        annot=len(numerical_cols) <= 15,
        cmap="coolwarm",
        center=0,
        fmt=".2f",
        square=True
    )
    plt.title(f"{method.capitalize()} Correlation Matrix")
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=150, bbox_inches="tight")
    plt.show()


def detect_outliers(
    df: pd.DataFrame,
    cols: list[str] | None = None,
    method: str = "iqr",
    threshold: float = 1.5
) -> pd.DataFrame:
    """
    Detect outliers in numerical columns.
    
    Args:
        df: Input DataFrame
        cols: List of columns to check (defaults to all numerical)
        method: Detection method ("iqr", "zscore")
        threshold: Threshold for outlier detection
        
    Returns:
        DataFrame with outlier statistics
    """
    if cols is None:
        cols = df.select_dtypes(include=[np.number]).columns.tolist()
    
    outlier_stats = []
    
    for col in cols:
        if method == "iqr":
            Q1 = df[col].quantile(0.25)
            Q3 = df[col].quantile(0.75)
            IQR = Q3 - Q1
            outliers = ((df[col] < Q1 - threshold * IQR) | (df[col] > Q3 + threshold * IQR))
        elif method == "zscore":
            z_scores = np.abs((df[col] - df[col].mean()) / df[col].std())
            outliers = z_scores > threshold
        else:
            raise ValueError(f"Unknown method: {method}")
        
        outlier_stats.append({
            "column": col,
            "outlier_count": outliers.sum(),
            "outlier_pct": (outliers.sum() / len(df)) * 100
        })
    
    return pd.DataFrame(outlier_stats).sort_values("outlier_pct", ascending=False)
