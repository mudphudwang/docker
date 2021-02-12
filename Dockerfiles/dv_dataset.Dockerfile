# mudphudwang/dv_dataset

FROM mudphudwang/lab

# To solve bug with ruamel.yml package: https://github.com/jupyterhub/jupyterhub/issues/3145
RUN conda install -y -c conda-forge ruamel.yaml 

# Install CaImAn and its dependencies
WORKDIR /src
RUN git clone https://github.com/mudphudwang/CaImAn.git -b master --single-branch 
RUN pip install -r /src/CaImAn/requirements.txt
RUN pip install -e /src/CaImAn/
WORKDIR /workspace