# Makefile

# Variables
IMAGE_NAME   := pytorch-rocm
USER_ID      := $(shell id -u)
GROUP_ID     := $(shell id -g)
CURRENT_DIR  := $(shell pwd)

# Build target
.PHONY: build
build:
	@echo "Building Docker image: $(IMAGE_NAME)"
	docker build -t $(IMAGE_NAME) .

# Run target
.PHONY: run original
run:
	@echo "Running Docker container from image: $(IMAGE_NAME)"
	sudo docker run -it \
	    --cap-add=SYS_PTRACE \
	    --security-opt seccomp=unconfined \
	    --ipc=host \
	    --shm-size 8G \
	    --device=/dev/dxg \
	    -v /usr/lib/wsl/lib/libdxcore.so:/usr/lib/libdxcore.so \
	    -v /opt/rocm/lib/libhsa-runtime64.so.1:/opt/rocm/lib/libhsa-runtime64.so.1 \
	    -p 8888:8888 \
	    -v $(CURRENT_DIR):/workspace:rw \
	    --user $(USER_ID):$(GROUP_ID) \
	    $(IMAGE_NAME)
original:
	@echo "Running base Docker container from image: rocm/pytorch:rocm6.3.1_ubuntu22.04_py3.10_pytorch"
	sudo docker run -it \
	    --cap-add=SYS_PTRACE \
	    --security-opt seccomp=unconfined \
	    --ipc=host \
	    --shm-size 8G \
	    --device=/dev/dxg \
		--security-opt seccomp=unconfined --group-add video --privileged \
	    -v /usr/lib/wsl/lib/libdxcore.so:/usr/lib/libdxcore.so \
	    -v /opt/rocm/lib/libhsa-runtime64.so.1:/opt/rocm/lib/libhsa-runtime64.so.1 \
	    -v $(CURRENT_DIR):/workspace:rw \
	    --user $(USER_ID):$(GROUP_ID) rocm_ct2_v3.23.0