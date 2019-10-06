# mudphudwang/lab

FROM mudphudwang/base

RUN /opt/conda/bin/conda install -y -c pytorch pytorch=1.2.0 torchvision=0.4 cudatoolkit=10.0 && \
    /opt/conda/bin/conda install -y -c conda-forge av=6.2.0 && \
    /opt/conda/bin/conda clean -ya

RUN pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/cuda/10.0 \
    nvidia-dali==0.14.0 \
    scipy==1.3.1 \
    matplotlib==3.1.1 \
    seaborn==0.9.0 \
    pandas==0.25.1 \
    h5py==2.10.0 \
    gitpython==3.0.3 \
    scikit-image==0.15.0 \
    scikit-video==1.1.11 \
    graphviz==0.13 \
    datajoint==0.11.3

RUN pip uninstall -y pillow && \
    pip install pillow-simd==6.0.0.post0