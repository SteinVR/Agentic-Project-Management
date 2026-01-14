"""
Data loading, cleaning, and transformation functions.

This module handles all data I/O operations and basic preprocessing.
"""

import pandas as pd
from pathlib import Path


def load_data(path: str | Path) -> pd.DataFrame:
    """
    Load data from file.
    
    Args:
        path: Path to data file (csv, parquet, etc.)
        
    Returns:
        Loaded DataFrame
    """
    path = Path(path)
    
    if path.suffix == ".csv":
        return pd.read_csv(path)
    elif path.suffix == ".parquet":
        return pd.read_parquet(path)
    else:
        raise ValueError(f"Unsupported file format: {path.suffix}")


def save_data(df: pd.DataFrame, path: str | Path) -> None:
    """
    Save DataFrame to file.
    
    Args:
        df: DataFrame to save
        path: Output path
    """
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    
    if path.suffix == ".csv":
        df.to_csv(path, index=False)
    elif path.suffix == ".parquet":
        df.to_parquet(path, index=False)
    else:
        raise ValueError(f"Unsupported file format: {path.suffix}")


def split_data(
    df: pd.DataFrame,
    target_col: str,
    train_ratio: float = 0.7,
    val_ratio: float = 0.15,
    random_state: int = 42,
    stratify: bool = True
) -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    """
    Split data into train/validation/test sets.
    
    Args:
        df: Input DataFrame
        target_col: Name of target column
        train_ratio: Proportion for training set
        val_ratio: Proportion for validation set
        random_state: Random seed for reproducibility
        stratify: Whether to stratify by target
        
    Returns:
        Tuple of (train_df, val_df, test_df)
    """
    from sklearn.model_selection import train_test_split
    
    stratify_col = df[target_col] if stratify else None
    
    # First split: train vs (val + test)
    train_df, temp_df = train_test_split(
        df, 
        train_size=train_ratio,
        random_state=random_state,
        stratify=stratify_col
    )
    
    # Second split: val vs test
    val_size = val_ratio / (1 - train_ratio)
    stratify_col = temp_df[target_col] if stratify else None
    
    val_df, test_df = train_test_split(
        temp_df,
        train_size=val_size,
        random_state=random_state,
        stratify=stratify_col
    )
    
    return train_df, val_df, test_df
