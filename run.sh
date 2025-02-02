sudo docker run -it \
    --cap-add=SYS_PTRACE \
    --security-opt seccomp=unconfined \
    --ipc=host \
    --shm-size 8G \
    --device=/dev/dxg \
    -v /usr/lib/wsl/lib/libdxcore.so:/usr/lib/libdxcore.so \
    -v /opt/rocm/lib/libhsa-runtime64.so.1:/opt/rocm/lib/libhsa-runtime64.so.1 \
    -p 8888:8888 \
    -v $(pwd):/app:rw \
    --user $(id -u):$(id -g) \
    pytorch-rocm