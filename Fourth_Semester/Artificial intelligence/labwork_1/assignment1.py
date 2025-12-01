# -*- coding: utf-8 -*-
"""
Created on Wed Mar  5 07:28:19 2025

@author: gintautasd
"""

import sklearn
import sklearn.model_selection
import sklearn.neighbors
from sklearn.model_selection import train_test_split
#from sklearn import tree
#from sklearn import ensemble
from sklearn import svm
import pandas as pd

# Load dataset
df = pd.read_csv('D:/AI/39_Ecoli/ecoli.data', sep=r'\s+', header=None)

X = df.iloc[:, 1:-1]  # Skips the first column (ID) and selects features
y = df.iloc[:, -1]  # Last column as target


# Split into training and test sets
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=42, stratify=y
)


# Feature scaling
scaler = sklearn.preprocessing.StandardScaler()
X_train= scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

# Initialize classifier
#klasif = sklearn.neighbors.KNeighborsClassifier(n_neighbors=3, weights='distance')
#klasif = tree.DecisionTreeClassifier(criterion='gini', max_depth=3,  min_samples_split=5)
#klasif = ensemble.RandomForestClassifier(criterion='entropy')
klasif = svm.SVC()
klasif.fit(X_train, y_train)

# Predict on the test set
y_pred = klasif.predict(X_test)

# Evaluate
accuracy = sklearn.metrics.accuracy_score(y_test, y_pred)
print('Accuracy on test set:', accuracy)
precision = sklearn.metrics.precision_score(y_test, y_pred, average=None, zero_division=1)
print('Precision on test set:', precision)
recall = sklearn.metrics.recall_score(y_test, y_pred, average=None, zero_division=1)
print('Recall on test set:', recall)
f1 = sklearn.metrics.f1_score(y_test, y_pred, average=None)
print('F1 on test set:', f1)
conf_mat = sklearn.metrics.confusion_matrix(y_test, y_pred)
print(conf_mat)

