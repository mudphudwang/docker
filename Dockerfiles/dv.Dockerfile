# mudphudwang/dv

FROM mudphudwang/lab

WORKDIR /src
RUN git clone https://github.com/flatironinstitute/CaImAn -b v1.8.6 --single-branch
RUN pip install -e CaImAn

WORKDIR /workspace