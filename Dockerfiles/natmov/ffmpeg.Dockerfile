# mudphudwang/natmov:bionic-python3.7-cuda10.0-ffmpeg3.4.6

FROM mudphudwang/python:bionic-python3.7-cuda10.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg=7:3.4.6-0ubuntu0.18.04.1 && \
    rm -rf /var/lib/apt/lists/*

RUN pip install gitpython
RUN pip install scikit-image==0.15.0
RUN pip install scikit-video==1.1.11
RUN pip install pyparsing==2.4.0
RUN pip install datajoint==0.11.1