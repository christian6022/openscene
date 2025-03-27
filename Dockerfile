FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime

WORKDIR /openscene

RUN apt-get update \
    && apt-get install -y \
    build-essential \
    tmux \
    cmake \
    git \
    curl \
    wget \
    gnupg2 \
    software-properties-common \
    libopenexr-dev \
    python3-dev \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

# NVIDIAリポジトリの追加
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin -O /etc/apt/preferences.d/cuda-repository-pin-600 \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub \
    && add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" \
    && apt-get update

# CUDA Toolkitのインストール
RUN apt-get install -y cuda-toolkit-11-0 \
    && rm -rf /var/lib/apt/lists/*

# 環境変数の設定
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=$CUDA_HOME/bin:${PATH}
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:${LD_LIBRARY_PATH}

COPY . /openscene/

# Pythonの依存パッケージをインストール
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --ignore-installed -r requirements.txt


