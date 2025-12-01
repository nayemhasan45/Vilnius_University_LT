from sklearn.cluster import KMeans, AgglomerativeClustering
import numpy as np
import matplotlib.pyplot as plt
import sklearn
from sklearn import datasets
from sklearn import model_selection
from sklearn.decomposition import PCA
from random import sample
import pandas as pd

# Load dataset
df = pd.read_csv('E:/ai/Algerian_forest_fires_dataset_UPDATE.csv', sep=r'\s+', header=None)

X = df.iloc[:, 1:-1]  # Skips the first column (ID) and selects features
y = df.iloc[:, -1]  # Last column as target

scaler = sklearn.preprocessing.StandardScaler()
X = scaler.fit_transform(X)


pca = PCA(n_components = 2)
pca.fit(X)
X_pca = pca.transform(X)

unniq_labels = np.unique(y)
nlabels = len(unniq_labels)
Ncolors = nlabels

# Choose a colormap and generate Ncolors distinct colors
cmap = plt.get_cmap("rainbow")
colors = cmap(np.linspace(0, 1, Ncolors))

plt.figure(1)
for i,l in enumerate(unniq_labels):
    idxs = np.where(y==l)[0]
    plt.scatter(X_pca[idxs,0], X_pca[idxs,1], c=[colors[i]])
plt.legend(unniq_labels)

"""
nclusters = 10
print('nclusters:', nclusters)
clustering1 = KMeans(nclusters)
clusters = clustering1.fit_predict(X)

colors = cmap(np.linspace(0, 1, nclusters))
plt.figure(2)
for i,c in enumerate(clusters):
    plt.scatter(X_pca[i,0], X_pca[i,1], c=colors[c])
plt.legend(np.arange(nclusters))
Ns = np.zeros((nclusters,), dtype=np.int32)
for i in range(nclusters):
    Ns[i] = np.sum(clusters == i)
print("Elements in each cluster:", Ns)

nlabels = len(unniq_labels)
label_to_index = {label: idx for idx, label in enumerate(unniq_labels)}
y_int = y.map(label_to_index)
NNs = np.zeros((nlabels, nclusters), dtype=np.int32)
for t, p in zip(y_int, clusters):
    NNs[t, p] += 1 
print("Cluster stats:\n" , NNs)
plt.show()
"""
"""
nclusters = 12
print('nclusters:', nclusters)
clustering1 = KMeans(nclusters)
clusters = clustering1.fit_predict(X)
colors = cmap(np.linspace(0, 1, nclusters))
plt.figure(3)
for i,c in enumerate(clusters):
    plt.scatter(X_pca[i,0], X_pca[i,1], c=colors[c])
plt.legend(np.arange(nclusters))
Ns = np.zeros((nclusters,), dtype=np.int32)
for i in range(nclusters):
    Ns[i] = np.sum(clusters == i)
print("Elements in each cluster:", Ns)

nlabels = len(unniq_labels)
label_to_index = {label: idx for idx, label in enumerate(unniq_labels)}
y_int = y.map(label_to_index)
NNs = np.zeros((nlabels, nclusters), dtype=np.int32)
for t, p in zip(y_int, clusters):
    NNs[t, p] += 1 
print("Cluster stats:\n" , NNs)
plt.show()
"""
"""
nclusters = 15
print('nclusters:', nclusters)
clustering1 = KMeans(nclusters)
clusters = clustering1.fit_predict(X)
colors = cmap(np.linspace(0, 1, nclusters))
plt.figure(4)
for i,c in enumerate(clusters):
    plt.scatter(X_pca[i,0], X_pca[i,1], c=colors[c])
plt.legend(np.arange(nclusters))
Ns = np.zeros((nclusters,), dtype=np.int32)
for i in range(nclusters):
    Ns[i] = np.sum(clusters == i)
print("Elements in each cluster:", Ns)

nlabels = len(unniq_labels)
label_to_index = {label: idx for idx, label in enumerate(unniq_labels)}
y_int = y.map(label_to_index)
NNs = np.zeros((nlabels, nclusters), dtype=np.int32)
for t, p in zip(y_int, clusters):
    NNs[t, p] += 1 
print("Cluster stats:\n" , NNs)
plt.show()
"""
"""
print('AgglomerativeClustering, linkage: average')
clustering = AgglomerativeClustering(linkage='average',n_clusters=None, distance_threshold=45)
clustering.fit(X)
clusters = clustering.labels_
nclusters = len(np.unique(clusters))
print('Number of clusters:', nclusters)
Ns = np.zeros((nclusters,), dtype=np.int32)
for i in range(nclusters):
    Ns[i] = np.sum(clusters == i)
print("Elements in each cluster:", Ns)
  
NNs = np.zeros((nlabels, nclusters), dtype=np.int32)
# Convert string labels in y to integers
label_to_index = {label: idx for idx, label in enumerate(unniq_labels)}
y_indices = np.array([label_to_index[label] for label in y])
for t, p in zip(y_indices, clusters):
    NNs[t, p] += 1
print("Cluster stats:\n" , NNs)  

colors = cmap(np.linspace(0, 1, nclusters))    
plt.figure(5)
for i,c in enumerate(clusters):
    plt.scatter(X_pca[i,0], X_pca[i,1], c=[colors[c]])
plt.legend(np.arange(nclusters))
plt.title('Linkage: average')
plt.show()
"""
"""
print('AgglomerativeClustering, linkage: single')
clustering = AgglomerativeClustering(linkage='single',n_clusters=None, distance_threshold=25)
clustering.fit(X)
clusters = clustering.labels_
nclusters = len(np.unique(clusters))
print('Number of clusters:', nclusters)

Ns = np.zeros((nclusters,), dtype=np.int32)
for i in range(nclusters):
    Ns[i] = np.sum(clusters == i)
print("Elements in each cluster:", Ns)
  
NNs = np.zeros((nlabels, nclusters), dtype=np.int32)
# Convert string labels in y to integers
label_to_index = {label: idx for idx, label in enumerate(unniq_labels)}
y_indices = np.array([label_to_index[label] for label in y])
for t, p in zip(y_indices, clusters):
    NNs[t, p] += 1 
print("Cluster stats:\n" , NNs)  

colors = cmap(np.linspace(0, 1, nclusters))    
plt.figure(6)
for i,c in enumerate(clusters):
    plt.scatter(X_pca[i,0], X_pca[i,1], color=colors[c])
plt.legend(np.arange(nclusters))
plt.title('Linkage: single')
plt.show()
"""
print('AgglomerativeClustering, linkage: complete')
clustering = AgglomerativeClustering(linkage='complete',n_clusters=None, distance_threshold=5)
clustering.fit(X)
clusters = clustering.labels_
nclusters = len(np.unique(clusters))
print('Number of clusters:', nclusters)

Ns = np.zeros((nclusters,), dtype=np.int32)
for i in range(nclusters):
    Ns[i] = np.sum(clusters == i)
print("Elements in each cluster:", Ns)
  
NNs = np.zeros((nlabels, nclusters), dtype=np.int32)
# Convert string labels in y to integers
label_to_index = {label: idx for idx, label in enumerate(unniq_labels)}
y_indices = np.array([label_to_index[label] for label in y])
for t, p in zip(y_indices, clusters):
    NNs[t, p] += 1 
print("Cluster stats:\n" , NNs)  

colors = cmap(np.linspace(0, 1, nclusters))    
plt.figure(6)
for i,c in enumerate(clusters):
    plt.scatter(X_pca[i,0], X_pca[i,1], color=colors[c])
plt.legend(np.arange(nclusters))
plt.title('Linkage: complete')
plt.show()
