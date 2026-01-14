"""
Feature engineering functions.

This module contains functions for creating, transforming, and selecting features.
"""

import pandas as pd
import numpy as np


def create_features(df: pd.DataFrame) -> pd.DataFrame:
    """
    Apply all feature engineering transformations.
    
    Args:
        df: Input DataFrame
        
    Returns:
        DataFrame with engineered features
    """
    df = df.copy()
    # Add feature engineering logic here
    return df


# Example feature engineering functions:

def create_datetime_features(df: pd.DataFrame, date_col: str) -> pd.DataFrame:
    """
    Extract datetime features from a date column.
    
    Args:
        df: Input DataFrame
        date_col: Name of datetime column
        
    Returns:
        DataFrame with added datetime features
    """
    df = df.copy()
    df[date_col] = pd.to_datetime(df[date_col])
    
    df[f"{date_col}_year"] = df[date_col].dt.year
    df[f"{date_col}_month"] = df[date_col].dt.month
    df[f"{date_col}_day"] = df[date_col].dt.day
    df[f"{date_col}_dayofweek"] = df[date_col].dt.dayofweek
    df[f"{date_col}_is_weekend"] = df[date_col].dt.dayofweek.isin([5, 6]).astype(int)
    
    return df


def encode_categorical(
    df: pd.DataFrame, 
    cols: list[str], 
    method: str = "onehot"
) -> pd.DataFrame:
    """
    Encode categorical columns.
    
    Args:
        df: Input DataFrame
        cols: List of columns to encode
        method: Encoding method ("onehot", "label", "target")
        
    Returns:
        DataFrame with encoded columns
    """
    df = df.copy()
    
    if method == "onehot":
        df = pd.get_dummies(df, columns=cols, drop_first=True)
    elif method == "label":
        from sklearn.preprocessing import LabelEncoder
        for col in cols:
            le = LabelEncoder()
            df[col] = le.fit_transform(df[col].astype(str))
    else:
        raise ValueError(f"Unknown encoding method: {method}")
    
    return df


def scale_numerical(
    df: pd.DataFrame,
    cols: list[str],
    method: str = "standard"
) -> pd.DataFrame:
    """
    Scale numerical columns.
    
    Args:
        df: Input DataFrame
        cols: List of columns to scale
        method: Scaling method ("standard", "minmax", "robust")
        
    Returns:
        DataFrame with scaled columns
    """
    df = df.copy()
    
    if method == "standard":
        from sklearn.preprocessing import StandardScaler
        scaler = StandardScaler()
    elif method == "minmax":
        from sklearn.preprocessing import MinMaxScaler
        scaler = MinMaxScaler()
    elif method == "robust":
        from sklearn.preprocessing import RobustScaler
        scaler = RobustScaler()
    else:
        raise ValueError(f"Unknown scaling method: {method}")
    
    df[cols] = scaler.fit_transform(df[cols])
    return df
