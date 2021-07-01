# mudphudwang/dv

FROM nvidia/cuda:11.2.0-cudnn8-devel-ubuntu18.04

ARG PYTHON_VERSION=3.7

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    curl \
    vim \
    ca-certificates \
    libjpeg-dev \
    libpng-dev \
    unzip \
    rsync \
    openssh-server \
    libhdf5-dev \
    libsm6 \
    libgl1-mesa-glx \
    graphviz \
    fish \
    firefox && \
    rm -rf /var/lib/apt/lists/*

RUN curl -v -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y -c conda-forge \
    python=$PYTHON_VERSION \
    av=8.0.3 \
    jupyterlab=3.0.16 \
    plotly=4.14.3 \
    bokeh=2.3.2 \
    selenium=3.141.0 \
    geckodriver=0.29.0 \
    python-kaleido=0.2.1 \
    nodejs=15.14.0 && \
    /opt/conda/bin/conda install -y -c pyviz \
    datashader=0.13.0 \
    holoviews=1.14.4 && \
    /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH

EXPOSE 8888
ADD ./add/jupyter_lab_config.py /root/.jupyter/

RUN jupyter labextension install jupyterlab-plotly@4.14.3

# Hack to deal with weird bug that prevents running `jupyter notebook` directly
# from Docker ENTRYPOINT or CMD.
# Use dumb shell script that runs `jupyter notebook` :(
# https://github.com/ipython/ipython/issues/7062
RUN mkdir -p /scripts
ADD ./add/run_jupyter.sh /scripts/
RUN chmod -R a+x /scripts
ENTRYPOINT ["/scripts/run_jupyter.sh"]

WORKDIR /workspace
RUN chmod -R a+w /workspace

RUN pip install \
    gitpython==3.1.18 \
    graphviz==0.16 \
    wget==3.2 \
    xlrd==2.0.1 \
    Jinja2==3.0.1 \
    imageio==2.9.0 \
    imageio-ffmpeg==0.4.4 \
    opencv-python==4.5.2.54 \
    Pillow==8.2.0 \
    h5py==3.3 \
    numpy==1.21.0 \
    scipy==1.7.0 \
    pandas==1.2.5 \
    xarray==0.18.2 \
    matplotlib==3.4.2 \
    seaborn==0.11.1 \
    networkx==2.5.1 \
    datajoint==0.13.2 \
    streamlit==0.83.0 \
    statsmodels==0.12.2 \
    scikit-image==0.18.2 \
    scikit-video==1.1.11 \
    scikit-learn==0.24.2 \
    pynndescent==0.5.2 \
    umap-learn==0.5.1 \
    hdbscan==0.8.27

RUN pip install \
    torch==1.9.0+cu111 \
    torchvision==0.10.0+cu111 \
    -f https://download.pytorch.org/whl/torch_stable.html

RUN pip cache purge
