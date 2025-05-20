# -*- coding: utf-8 -*-
"""
Created on Sun Apr 6 10:49:57 2025
@author: ginta
"""

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader
import numpy as np
import matplotlib.pyplot as plt

# Define the Dataset
class TimeSeriesDataset(Dataset):
    def __init__(self, series, input_window=24, output_window=4):
        self.series = series
        self.input_window = input_window
        self.output_window = output_window
        self.samples = []
        for i in range(len(series) - input_window - output_window + 1):
            x = series[i : i + input_window]
            y = series[i + input_window : i + input_window + output_window]
            self.samples.append((x, y))
    
    def __len__(self):
        return len(self.samples)
    
    def __getitem__(self, index):
        x, y = self.samples[index]
        return torch.tensor(x, dtype=torch.float32).unsqueeze(-1), torch.tensor(y, dtype=torch.float32)

# Define the Model
class LSTMModel(nn.Module):
    def __init__(self, input_size=1, hidden_size=128, num_layers=2, output_size=4):
        super(LSTMModel, self).__init__()
        self.hidden_size = hidden_size
        self.num_layers = num_layers
        
        self.lstm = nn.LSTM(input_size, hidden_size, num_layers, batch_first=True, dropout=0.2)
        self.fc = nn.Linear(hidden_size, output_size)
    
    def forward(self, x):
        h0 = torch.zeros(self.num_layers, x.size(0), self.hidden_size).to(x.device)
        c0 = torch.zeros(self.num_layers, x.size(0), self.hidden_size).to(x.device)
        out, _ = self.lstm(x, (h0, c0))
        out = out[:, -1, :]
        out = self.fc(out)
        return out

# Load and normalize the data
train = np.load('2018_01_so2.npy')
test = np.load('2018_02_so2.npy')

# Normalize
train_mean = train.mean()
train_std = train.std()

train = (train - train_mean) / train_std
test = (test - train_mean) / train_std

# Create Dataset and DataLoader
dataset = TimeSeriesDataset(train, input_window=24, output_window=4)
dataloader = DataLoader(dataset, batch_size=64, shuffle=True)

# Hyperparameters
num_epochs = 150
learning_rate = 0.001

# Model, Loss, Optimizer
model = LSTMModel(input_size=1, hidden_size=128, num_layers=2, output_size=4)
criterion = nn.MSELoss()
optimizer = optim.Adam(model.parameters(), lr=learning_rate)

# Training loop
for epoch in range(num_epochs):
    model.train()
    epoch_loss = 0.0
    for x_batch, y_batch in dataloader:
        optimizer.zero_grad()
        predictions = model(x_batch)
        loss = criterion(predictions, y_batch)
        loss.backward()
        optimizer.step()
        epoch_loss += loss.item()
    
    avg_loss = epoch_loss / len(dataloader)
    print(f"Epoch {epoch+1}/{num_epochs}, Loss: {avg_loss:.6f}")

# Testing
model.eval()
dataset_test = TimeSeriesDataset(test, input_window=24, output_window=4)
full_batch_loader = DataLoader(dataset_test, batch_size=len(dataset_test), shuffle=False)

for x_full, y_full in full_batch_loader:
    with torch.no_grad():
        predictions = model(x_full)

# Calculate total test loss
total_loss = criterion(predictions, y_full)
print(f"\nTotal Test Loss (MSE): {total_loss:.6f}")

# Calculate individual losses for each of the 4 output steps
for i in range(4):
    step_loss = criterion(predictions[:,i], y_full[:,i])
    print(f"Test Loss for {i+1} hour(s) ahead: {step_loss:.6f}")

# Convert predictions and targets back to numpy (and denormalize for plotting if needed)
Predictions = predictions.cpu().numpy() * train_std + train_mean
Targets = y_full.cpu().numpy() * train_std + train_mean

# Plot true vs predicted for each forecast step
for i in range(4):
    plt.figure(figsize=(10, 4))
    plt.plot(Targets[:,i], label="True Values")
    plt.plot(Predictions[:,i], label="Predicted Values")
    plt.title(f"SO₂ Concentration Prediction {i+1} hour(s) ahead")
    plt.xlabel("Sample Index")
    plt.ylabel("SO₂ Concentration")
    plt.legend()
    plt.grid(True)
    plt.show()
