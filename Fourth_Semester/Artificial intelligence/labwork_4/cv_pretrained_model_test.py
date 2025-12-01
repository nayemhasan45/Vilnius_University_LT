import os
import numpy as np
import torch
from torchvision import models, transforms
from PIL import Image
import json

# Load ImageNet class labels
with open('imagenet_class_index.json') as f:
    labels = json.load(f)

# Define models to compare
model_names = ['resnet18', 'resnet50', 'mobilenet_v2']
models_dict = {
    'resnet18': models.resnet18(pretrained=True),
    'resnet50': models.resnet50(pretrained=True),
    'mobilenet_v2': models.mobilenet_v2(pretrained=True)
}

# Transform for input image
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

# Folder with images
image_folder = "cucumber"
image_files = [f for f in os.listdir(image_folder) if f.endswith(('.jpg', '.jpeg', '.png'))]

results = {}

for name in model_names:
    model = models_dict[name]
    model.eval()
    correct = 0
    misclassifications = {}

    for file in image_files:
        img_path = os.path.join(image_folder, file)
        image = Image.open(img_path).convert("RGB")
        input_tensor = transform(image).unsqueeze(0)

        with torch.no_grad():
            output = model(input_tensor)
            probs = torch.nn.functional.softmax(output[0], dim=0)
            top_prob, top_idx = torch.max(probs, dim=0)

        label = labels[str(top_idx.item())][1]

        if 'cucumber' in label.lower():
            correct += 1
        else:
            misclassifications[label] = misclassifications.get(label, 0) + 1

    total = len(image_files)
    accuracy = correct / total * 100
    results[name] = {'accuracy': accuracy, 'correct': correct, 'misclassified': misclassifications}

# Display results
for model_name, data in results.items():
    print(f"\nModel: {model_name}")
    print(f"Accuracy: {data['accuracy']:.2f}%")
    print(f"Correct: {data['correct']} out of {len(image_files)}")
    print("Misclassified classes:")
    for cls, count in data['misclassified'].items():
        print(f"{cls}: {count} images")