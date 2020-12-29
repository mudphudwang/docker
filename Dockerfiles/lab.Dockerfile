# mudphudwang/lab

FROM mudphudwang/base

RUN pip install \
    gitpython==3.1.11 \
    graphviz==0.15 \
    wget==3.2 \
    xlrd==1.2.0 \
    imageio==2.9.0 \
    imageio-ffmpeg==0.4.2 \
    opencv-python==4.4.0.46 \
    Pillow==8.0.1 \
    h5py==3.1.0 \
    numpy==1.19.4 \
    scipy==1.5.4 \
    pandas==1.2.0 \
    matplotlib==3.3.3 \
    seaborn==0.11.1 \
    statsmodels==0.12.1 \
    scikit-image==0.18.1 \
    scikit-video==1.1.11 \
    scikit-learn==0.24.0 \
    umap-learn==0.4.6 \
    hdbscan==0.8.26 \
    networkx==2.5 \
    datajoint==0.12.7 \
    jupyterlab==3.0.0

RUN pip install \
    torch==1.7.1+cu110 \
    torchvision==0.8.2+cu110 \
    -f https://download.pytorch.org/whl/torch_stable.html

RUN pip cache purge

EXPOSE 8888
ADD ./add/jupyter_lab_config.py /root/.jupyter/

# Hack to deal with weird bug that prevents running `jupyter notebook` directly
# from Docker ENTRYPOINT or CMD.
# Use dumb shell script that runs `jupyter notebook` :(
# https://github.com/ipython/ipython/issues/7062
RUN mkdir -p /scripts
ADD ./add/run_jupyter.sh /scripts/
RUN chmod -R a+x /scripts
ENTRYPOINT ["/scripts/run_jupyter.sh"]

