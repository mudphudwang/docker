# mudphudwang/lab

FROM mudphudwang/base

RUN /opt/conda/bin/conda install -y -c conda-forge av=7.0.1 && \
    /opt/conda/bin/conda install -y -c pytorch pytorch=1.4.0 cudatoolkit=10.1 && \
    /opt/conda/bin/conda clean -ya

RUN git clone --single-branch --branch v0.5.0 https://github.com/pytorch/vision.git vision && \
    cd vision && \
    python setup.py install && \
    cd .. && \
    rm -rf vision

RUN pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/cuda/10.0 \
    nvidia-dali==0.19.0 \
    scipy==1.4.1 \
    matplotlib==3.2.0 \
    seaborn==0.10.0 \
    pandas==1.0.1 \
    xlrd==1.2.0 \
    statsmodels==0.11.1 \
    h5py==2.10.0 \
    gitpython==3.1.0 \
    opencv-python==4.2.0.32 \
    scikit-image==0.16.2 \
    scikit-video==1.1.11 \
    scikit-learn==0.22.2.post1 \
    graphviz==0.13.2 \
    wget==3.2 \
    datajoint==0.12.5

RUN pip uninstall -y pillow && \
    pip install pillow-simd==7.0.0.post3

