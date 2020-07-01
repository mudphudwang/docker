# mudphudwang/lab

FROM mudphudwang/base

RUN /opt/conda/bin/conda install -y -c conda-forge jupyterlab && \
    /opt/conda/bin/conda clean -ya

RUN /opt/conda/bin/conda install -y -c conda-forge jupyterlab av=8.0.2 && \
    /opt/conda/bin/conda install -y -c pytorch pytorch=1.5.1 torchvision=0.6.1 cudatoolkit=10.2 && \
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
    scipy==1.5.0 \
    matplotlib==3.2.2 \
    seaborn==0.10.1 \
    pandas==1.0.5 \
    xlrd==1.2.6 \
    statsmodels==0.11.1 \
    h5py==2.10.0 \
    gitpython==3.1.3 \
    opencv-python==4.2.0.34 \
    scikit-image==0.17.2 \
    scikit-video==1.1.11 \
    scikit-learn==0.23.1 \
    graphviz==0.14 \
    wget==3.2 \
    datajoint==0.12.6

RUN pip uninstall -y pillow && \
    pip install pillow-simd==7.0.0.post3

