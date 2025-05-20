import numpy as np

from sklearn.datasets import load_iris
from sklearn import metrics
from sklearn import model_selection
from sklearn.utils import shuffle
import sklearn.preprocessing
import torch
import torch.nn as nn
import torch.nn.functional as F
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.preprocessing import LabelEncoder


# Load dataset
df = pd.read_csv('D:/AI/labwork_3/39_Ecoli/ecoli.data', sep=r'\s+', header=None)

X = df.iloc[:, 1:-1]  # Skips the first column (ID) and selects features
y = df.iloc[:, -1]  # Last column as target

scaler = sklearn.preprocessing.StandardScaler()
X = scaler.fit_transform(X)

X_train, X_test, y_train, y_test = model_selection.train_test_split(X, y, 
                                    test_size=0.2, random_state=1)

# Convert string labels to integers
label_encoder = LabelEncoder()
y_train = label_encoder.fit_transform(y_train)
y_test = label_encoder.transform(y_test)

y_train = np.array(y_train, dtype=np.int64)
y_test = np.array(y_test, dtype=np.int64)

N1 = len(y_train)
N2 = len(y_test)

if torch.cuda.is_available():
    device = 'cuda'
else:
    device = 'cpu'


# Hyper-parameters 
input_size = X.shape[1]
num_classes = len(np.unique(y_train))
num_epochs = 500
batch_size = 22
learning_rate = 0.001


# Logistic regression model
class MLP(nn.Module):
    def __init__(self, input_size, num_classes):
        super(MLP, self).__init__()
        self.fc1 = nn.Linear(input_size, 64)
        self.fc2 = nn.Linear(64, num_classes)        
    def forward(self, x):
        x = self.fc1(x)
        x = F.relu(x)
        x = self.fc2(x)
        return x

model = MLP(input_size, num_classes)
model.to(device)
model.train()
# Loss and optimizer
# nn.CrossEntropyLoss() computes softmax internally
criterion = nn.CrossEntropyLoss()  
optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)  

# Train the model
total_step = int(N1 / batch_size)
losses = []
for epoch in range(num_epochs):
    x, y = shuffle(X_train, y_train)
    x = np.array(x, dtype=np.float32)
    
    for i in range(total_step):
        xb = x[i*batch_size : (i+1)*batch_size]
        xb = torch.from_numpy(xb).to(device)
        yb = y[i*batch_size : (i+1)*batch_size]
        labels = torch.from_numpy(yb).to(device)
        # Forward pass
        outputs = model(xb)
        loss = criterion(outputs, labels)
        
        # Backward and optimize
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        losses.append(loss.item())
        print ('Epoch %d/%d step %d/%d Loss: %.4f' %(epoch+1, num_epochs, i+1, total_step, loss.item()) )

# Test the model
# In test phase, we don't need to compute gradients (for memory efficiency)

plt.figure()
plt.plot(losses)
plt.show()

model.eval()
with torch.no_grad():
    xb = np.array(X_test, dtype=np.float32)
    xb = torch.from_numpy(xb).to(device)
    outputs = model(xb)
    _, predicted = torch.max(outputs.data, 1)
    y_pred = predicted.cpu().numpy()

# Save the model checkpoint
torch.save(model.state_dict(), 'model.ckpt')

acc = metrics.accuracy_score(y_test, y_pred)
print("NN acc: %f" %acc )

recall = metrics.recall_score(y_test, y_pred, average=None)
print("NN recall: %f",  recall )

prec = metrics.precision_score(y_test, y_pred, average=None)
print("NN precision:", prec )

f1 = metrics.f1_score(y_test, y_pred, average=None)
print("NN f1:", f1 )

conf_mat = metrics.confusion_matrix(y_test, y_pred)
print("NN conf_mat: %f")
print(conf_mat)
