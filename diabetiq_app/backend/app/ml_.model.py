import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.metrics import classification_report, confusion_matrix, roc_curve, auc
from imblearn.over_sampling import SMOTE
import xgboost as xgb
from collections import Counter # Used for displaying SMOTE results

# --- Configuration ---
# Set the path to your CSV file
csv_path = "/Users/saifmohammed/Desktop/DiabetIQ/ML/Test/Copy Dataset/Diabetes_Final_Data_V20.csv"
RANDOM_STATE = 42

# --- Data Loading and Preprocessing ---

def load_and_preprocess_data(file_path):
    """
    Loads the dataset and performs initial preprocessing steps.

    Args:
        file_path (str): The path to the CSV file.

    Returns:
        pandas.DataFrame: The processed DataFrame.
    """
    print("Loading data...")
    df = pd.read_csv(file_path)
    print(f"Initial data shape: {df.shape}")

    # Check for missing values (based on notebook output, none expected)
    print("Checking for missing values:")
    print(df.isnull().sum())

    # Check for duplicates (based on notebook output, none expected)
    print("Checking for duplicates:")
    print(df[df.duplicated()])

    # Handle outliers in 'age' using IQR method
    print("Handling outliers in 'age' column...")
    Q1 = df['age'].quantile(0.25)
    Q3 = df['age'].quantile(0.75)
    IQR = Q3 - Q1
    lower_bound = Q1 - (1.5 * IQR)
    upper_bound = Q3 + (1.5 * IQR)
    df_processed = df[(df['age'] >= lower_bound) & (df['age'] <= upper_bound)].copy()
    print(f"Data shape after outlier removal: {df_processed.shape}")

    # Encode categorical columns ('gender', 'diabetic') using LabelEncoder
    print("Encoding categorical features...")
    le = LabelEncoder()
    df_processed['gender'] = le.fit_transform(df_processed['gender'])
    # Note: We encode the target variable 'diabetic' now, as SMOTE requires numerical input
    df_processed['diabetic'] = le.fit_transform(df_processed['diabetic'])

    # Shuffle the dataset and reset index (drop=True prevents adding old index as a column)
    print("Shuffling data...")
    df_processed = df_processed.sample(frac=1, random_state=RANDOM_STATE).reset_index(drop=True)

    return df_processed

# --- Model Training and Evaluation ---

def train_and_evaluate_xgboost(X_train, X_test, y_train, y_test):
    """
    Trains an XGBoost classifier and evaluates its performance.

    Args:
        X_train (np.ndarray): Scaled and resampled training features.
        X_test (np.ndarray): Scaled test features.
        y_train (pandas.Series or np.ndarray): Resampled training target.
        y_test (pandas.Series or np.ndarray): Test target.
    """
    print("\n--- XGBoost Classifier ---")

    # Initialize and train the XGBoost classifier
    # Using default parameters for simplicity, as no GridSearch was shown for XGBoost
    print("Training XGBoost model...")
    xgb_clf = xgb.XGBClassifier(random_state=RANDOM_STATE)
    xgb_clf.fit(X_train, y_train)
    print("Training complete.")

    # Make predictions
    xgb_pred = xgb_clf.predict(X_test)

    # Evaluate the model
    print("\nXGBoost Model Evaluation:")

    # Accuracy
    accuracy = xgb_clf.score(X_test, y_test)
    print(f"Accuracy: {accuracy:.4f}")

    # Confusion Matrix
    cm = confusion_matrix(y_test, xgb_pred)
    print("\nConfusion Matrix:")
    print(cm)

    # Classification Report (includes precision, recall, f1-score)
    cr = classification_report(y_test, xgb_pred)
    print("\nClassification Report:")
    print(cr)

    # AUC Score
    # Need prediction probabilities for AUC
    xgb_pred_proba = xgb_clf.predict_proba(X_test)[:, 1]
    fpr, tpr, _ = roc_curve(y_test, xgb_pred_proba)
    auc_score = auc(fpr, tpr)
    print(f"\nArea under the ROC Curve (AUC): {auc_score:.4f}")

    # You could also save the trained model here if needed
    # import joblib
    # joblib.dump(xgb_clf, 'xgboost_model.pkl')
    # joblib.dump(scaler, 'scaler.pkl')
    # print("\nModel and scaler saved.")


# --- Main Execution ---

if __name__ == "__main__":
    # Load and preprocess data
    df_processed = load_and_preprocess_data(csv_path)

    # Define features (X) and target (Y)
    # 'index' column from reset_index should be dropped if not already
    if 'index' in df_processed.columns:
         X = df_processed.drop(['diabetic', 'index'], axis=1)
    else:
         X = df_processed.drop('diabetic', axis=1)
    Y = df_processed['diabetic']

    print(f"\nFeature data shape (X): {X.shape}")
    print(f"Target data shape (Y): {Y.shape}")
    print("\nTarget distribution:")
    print(Y.value_counts())
    print(f"Target distribution (%): {(Y.value_counts() / len(Y) * 100).round(2)}")


    # Split data into training and testing sets (stratified)
    print("\nSplitting data into training and testing sets...")
    X_train, X_test, y_train, y_test = train_test_split(
        X, Y, test_size=0.2, random_state=RANDOM_STATE, stratify=Y
    )
    print(f"Training data shape: {X_train.shape}")
    print(f"Testing data shape: {X_test.shape}")
    print("Training target distribution:", Counter(y_train))
    print("Testing target distribution:", Counter(y_test))


    # Scale numerical features
    print("\nScaling numerical features...")
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    print("Scaling complete.")


    # Apply SMOTE to the training data
    print("\nApplying SMOTE to training data...")
    # Using sampling_strategy=0.7 as in the notebook
    smote = SMOTE(sampling_strategy=0.7, random_state=RANDOM_STATE)
    X_train_resampled, y_train_resampled = smote.fit_resample(X_train_scaled, y_train)
    print("SMOTE complete.")
    print("Class distribution after SMOTE:", Counter(y_train_resampled))

    # Train and evaluate the XGBoost model
    train_and_evaluate_xgboost(X_train_resampled, X_test_scaled, y_train_resampled, y_test)
