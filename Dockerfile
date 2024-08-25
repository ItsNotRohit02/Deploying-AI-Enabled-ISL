FROM python:3.10-slim

WORKDIR /app

# Install essential tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    wget \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu \
    && pip3 install streamlit ultralytics transformers deep-translator \
    && git clone https://github.com/ItsNotRohit02/Deploying-AI-Enabled-ISL.git .

RUN cd models/ \
    && wget -O ISL-ViTImageClassification.pth https://huggingface.co/ItsNotRohit/ISL-Models/resolve/main/ISL-ViTImageClassification.pth?download=true \
    && wget -O ISL-YOLOv8mBoundingBox.pt https://huggingface.co/ItsNotRohit/ISL-Models/resolve/main/ISL-YOLOv8mBoundingBox.pt?download=true \
    && cd ..

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health || exit 1

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
