# mudphudwang/lab

FROM mudphudwang/base

RUN /opt/conda/bin/conda install -y -c conda-forge jupyterlab && \
    /opt/conda/bin/conda clean -ya

RUN /opt/conda/bin/conda install -y -c conda-forge jupyterlab av=7.0.1 && \
    /opt/conda/bin/conda install -y -c pytorch pytorch=1.5.0 torchvision=0.6.0 cudatoolkit=10.1 && \
    /opt/conda/bin/conda clean -ya

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

RUN pip install \
    scipy==1.4.1 \
    matplotlib==3.2.1 \
    seaborn==0.10.0 \
    pandas==1.0.3 \
    xlrd==1.2.0 \
    statsmodels==0.11.1 \
    h5py==2.10.0 \
    gitpython==3.1.1 \
    opencv-python==4.2.0.34 \
    scikit-image==0.16.2 \
    scikit-video==1.1.11 \
    scikit-learn==0.22.2.post1 \
    graphviz==0.14 \
    wget==3.2 \
    datajoint==0.12.5

RUN pip uninstall -y pillow && \
    pip install pillow-simd==7.0.0.post3

