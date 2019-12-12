import numpy as np
import pandas as pd
import time
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.naive_bayes import GaussianNB

df = pd.read_csv('data/data_500000s_128f.csv')

X = df.iloc[:, :-1]
y = df.iloc[:, -1]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

#rf = RandomForestClassifier(n_estimators=10, random_state=42)  
nb = GaussianNB()

#Train RF
time_train = []
for i in range(0,1):
    start = time.time()
    rf.fit(X_train, y_train)  
    end = time.time()
    time_train.append(end - start)
np.mean(time_train)

#Train NB
time_train = []
for i in range(0,11):
    start = time.time()
    nb.fit(X_train, y_train)  
    end = time.time()
    time_train.append(end - start)
np.mean(time_train)

#Predictions (always with 100k datasets)
df = pd.read_csv('data/data_100000s_128f.csv')

X = df.iloc[:, :-1]
y = df.iloc[:, -1]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

#rf = RandomForestClassifier(n_estimators=10, random_state=42)  
nb = GaussianNB()
nb.fit(X_train, y_train)  

#Predict
time_pred = []
for i in range(0,11):
    start = time.time()
    y_pred = nb.predict(X_test.iloc[0:30000, :])
    end = time.time()
    time_pred.append(end - start)
np.mean(time_pred)
