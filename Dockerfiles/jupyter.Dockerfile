# mudphudwang/jupyter

FROM mudphudwang/lab

RUN /opt/conda/bin/conda install -y -c conda-forge jupyterlab && \
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