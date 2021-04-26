# mudphudwang/dv_models

FROM mudphudwang/base

RUN pip install \
    gitpython==3.1.14 \
    graphviz==0.16 \
    wget==3.2 \
    xlrd==1.2.0 \
    imageio==2.9.0 \
    imageio-ffmpeg==0.4.3 \
    opencv-python==4.5.1.48 \
    Pillow==8.2.0 \
    h5py==3.2.1 \
    numpy==1.20.2 \
    scipy==1.6.2 \
    pandas==1.2.4 \
    matplotlib==3.4.1 \
    seaborn==0.11.1 \
    networkx==2.5.1 \
    datajoint==0.13.1 \
    jupyterlab==3.0.14 \
    streamlit==0.80.0 \
    statsmodels==0.12.2 \
    scikit-image==0.18.1 \
    scikit-video==1.1.11 \
    scikit-learn==0.24.1 \
    pynndescent==0.5.2 \
    umap-learn==0.5.1 \
    hdbscan==0.8.27

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
