# mudphudwang/natmov:bionic-python3.7-cuda10.0-ffmpeg3.4.6-pytorch1.2

FROM mudphudwang/natmov:bionic-python3.7-cuda10.0-ffmpeg3.4.6

RUN /opt/conda/bin/conda install -y -c pytorch pytorch torchvision  cudatoolkit=10.0 && \
    /opt/conda/bin/conda clean -ya

RUN pip uninstall -y pillow
RUN pip install pillow-simd==6.0.0.post0