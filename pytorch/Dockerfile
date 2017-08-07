FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
         python3.5 \
         python3-pip &&\
     rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.5 0 &&\
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 0

RUN pip install --upgrade pip
RUN pip install setuptools numpy scipy pandas matplotlib
RUN pip install http://download.pytorch.org/whl/cu80/torch-0.2.0.post1-cp35-cp35m-manylinux1_x86_64.whl
RUN pip install torchvision

ENV LANG en_US.UTF-8

WORKDIR /root/
