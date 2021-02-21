# mudphudwang/dv_datasets

FROM mudphudwang/lab

# To solve bug with ruamel.yml package: https://github.com/jupyterhub/jupyterhub/issues/3145
RUN conda install -y -c conda-forge ruamel.yaml 

# Install CaImAn and its dependencies
WORKDIR /src
RUN git clone https://github.com/mudphudwang/CaImAn.git -b master --single-branch 
RUN pip install -r /src/CaImAn/requirements.txt
RUN pip install -e /src/CaImAn/
WORKDIR /workspace

RUN pip install \
    torch==1.7.1+cu110 \
    torchvision==0.8.2+cu110 \
    -f https://download.pytorch.org/whl/torch_stable.html