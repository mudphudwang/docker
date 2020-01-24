# mudphudwang/lab

FROM mudphudwang/base

RUN /opt/conda/bin/conda install -y -c conda-forge av=6.2.0 && \
    /opt/conda/bin/conda install -y -c pytorch pytorch=1.4.0 cudatoolkit=10.1 && \
    /opt/conda/bin/conda clean -ya

RUN git clone --single-branch --branch v0.5.0 https://github.com/pytorch/vision.git vision && \
    cd vision && \
    python setup.py install && \
    cd .. && \
    rm -rf vision

RUN pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/cuda/10.0 \
    nvidia-dali==0.18.0 \
    scipy==1.3.1 \
    matplotlib==3.1.1 \
    seaborn==0.9.0 \
    pandas==0.25.1 \
    statsmodels==0.11.0 \
    h5py==2.10.0 \
    gitpython==3.0.3 \
    opencv-python==4.1.1.26 \
    scikit-image==0.15.0 \
    scikit-video==1.1.11 \
    graphviz==0.13 \
    datajoint==0.12.4

RUN pip uninstall -y pillow && \
    pip install pillow-simd==7.0.0.post2