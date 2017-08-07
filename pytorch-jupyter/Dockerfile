FROM mudphudwang/pytorch

RUN pip install jupyter

EXPOSE 8888

ADD ./jupyter_notebook_config.py /root/.jupyter/

CMD ["jupyter", "notebook", "--allow-root"]
