# mudphudwang/dv

FROM mudphudwang/lab

RUN conda install -y -c conda-forge caiman=1.8.5 && \
    conda clean -ya