# bionic-pytorch1.0-cuda10.0-v0

FROM mudphudwang/pytorch:bionic-pytorch1.0-cuda10.0

RUN /opt/conda/bin/conda install -y -c conda-forge jupyterlab=0.35.4 && \
     /opt/conda/bin/conda clean -ya

EXPOSE 8888

ADD ./jupyter_notebook_config.py /root/.jupyter/

# Hack to deal with weird bug that prevents running `jupyter notebook` directly
# from Docker ENTRYPOINT or CMD.
# Use dumb shell script that runs `jupyter notebook` :(
# https://github.com/ipython/ipython/issues/7062
RUN mkdir -p /scripts
ADD ./run_jupyter.sh /scripts/
RUN chmod -R a+x /scripts
ENTRYPOINT ["/scripts/run_jupyter.sh"]


RUN apt-get update && \
    apt-get install -y \
        openssh-server \
        ffmpeg \
        libhdf5-dev

RUN pip install imageio ffmpy h5py opencv-python statsmodels graphviz
RUN pip install datajoint==0.11.1