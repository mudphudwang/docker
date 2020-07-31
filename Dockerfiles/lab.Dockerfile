# mudphudwang/lab

FROM mudphudwang/base

RUN pip install \
    gitpython==3.1.7 \
    graphviz==0.14 \
    wget==3.2 \
    xlrd==1.2.0 \
    imageio==2.9.0 \
    imageio-ffmpeg==0.4.2 \
    opencv-python==4.3.0.36 \
    h5py==2.10.0 \
    numpy==1.19.1 \
    scipy==1.5.2 \
    pandas==1.0.5 \
    matplotlib==3.3.0 \
    seaborn==0.10.1 \
    statsmodels==0.11.1 \
    scikit-image==0.17.2 \
    scikit-video==1.1.11 \
    scikit-learn==0.23.1 \
    umap-learn==0.4.6 \
    hdbscan==0.8.26 \
    datajoint==0.12.6 \
    jupyterlab==2.2.0 \
    torch==1.6.0 \
    torchvision==0.7.0

EXPOSE 8888
ADD ./add/jupyter_notebook_config.py /root/.jupyter/

# Hack to deal with weird bug that prevents running `jupyter notebook` directly
# from Docker ENTRYPOINT or CMD.
# Use dumb shell script that runs `jupyter notebook` :(
# https://github.com/ipython/ipython/issues/7062
RUN mkdir -p /scripts
ADD ./add/run_jupyter.sh /scripts/
RUN chmod -R a+x /scripts
ENTRYPOINT ["/scripts/run_jupyter.sh"]

