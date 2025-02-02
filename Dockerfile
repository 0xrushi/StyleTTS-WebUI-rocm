# Base image with PyTorch and ROCm support
FROM rocm/pytorch:rocm6.3.1_ubuntu22.04_py3.10_pytorch

# Create a non-root user, set up workspace, install dependencies
RUN useradd -m -s /bin/bash jupyter_user && \
    mkdir -p /workspace/node_modules && \
    chown -R jupyter_user:jupyter_user /workspace && \
    chmod -R 755 /workspace && \
    apt-get update && \
    apt-get install -y \
    ffmpeg \
    git \
    curl \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /workspace

# Copy requirements before installing to leverage Docker caching
COPY requirements.txt /workspace/requirements.txt

# Install Python packages (data science stack + MLflow + tracking tools)
RUN pip3 install --no-cache-dir \
    jupyter jupyterlab jupyter-lsp \
    matplotlib seaborn scipy scikit-learn \
    mlflow hydra-core \
    wandb dvc dvc-gdrive \
    huggingface-hub accelerate \
    xgboost lightgbm \
    -r /workspace/requirements.txt

# Switch to non-root user
USER jupyter_user

# Expose Jupyter Notebook port
EXPOSE 8888

# Default command
CMD ["/bin/bash"]
