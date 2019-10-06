# mudphudwang/base

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
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
    graphviz \
    fish && \
    rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y python=$PYTHON_VERSION && \
    /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH

WORKDIR /workspace
RUN chmod -R a+w /workspace