FROM mudphudwang/pytorch

RUN pip install jupyter

EXPOSE 8888

ADD ./jupyter_notebook_config.py /root/.jupyter/

ENTRYPOINT ["jupyter", "notebook", "--allow-root"]
