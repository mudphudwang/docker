# mudphudwang/dv_models

FROM mudphudwang/base

RUN apt-get update && apt-get install -y --no-install-recommends \
    firefox && \
    rm -rf /var/lib/apt/lists/*

RUN /opt/conda/bin/conda install -y -c conda-forge \
    jupyterlab=3.0.14 \
    plotly=4.14.3 \
    bokeh=2.3.1 \
    selenium=3.141.0 \
    geckodriver=0.29.0 \
    python-kaleido=0.2.1 \
    nodejs=15.14.0 && \
    /opt/conda/bin/conda install -y -c pyviz \
    datashader=0.12.1 \
    holoviews=1.14.3 && \
    /opt/conda/bin/conda clean -ya

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

RUN pip install \
    gitpython==3.1.16 \
    graphviz==0.16 \
    wget==3.2 \
    xlrd==1.2.0 \
    Jinja2==3.0.0 \
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
    datajoint==0.13.2 \
    jupyterlab==3.0.14 \
    streamlit==0.80.0 \
    statsmodels==0.12.2 \
    scikit-image==0.18.1 \
    scikit-video==1.1.11 \
    scikit-learn==0.24.2 \
    pynndescent==0.5.2 \
    umap-learn==0.5.1 \
    hdbscan==0.8.27

RUN pip install \
    torch==1.8.1+cu111 \
    torchvision==0.9.1+cu111 \
    -f https://download.pytorch.org/whl/torch_stable.html

RUN pip cache purge
