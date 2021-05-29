# mudphudwang/pipeline

FROM at-docker.ad.bcm.edu:5000/pipeline:latest 

RUN pip3 install \
    jupyterlab==3.0.14

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