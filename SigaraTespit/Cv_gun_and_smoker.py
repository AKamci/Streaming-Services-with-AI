import torch
from ultralytics import YOLO

torch.cuda.empty_cache()
# Load a model
model = YOLO("yolov8n.pt")  # build a new model from scratch

if __name__ == '__main__':
    # İşlemler burada başlatılacak
    model.train(data='data.yaml', epochs=3)
    metrics = model.val()  # evaluate model performance on the validation set
    results = model("https://ultralytics.com/images/bus.jpg")  # predict on an image
    path = model.export(format="onnx")  # export the model to ONNX format   
