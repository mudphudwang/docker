# docker
Docker Images and GPU Management

Requirements: nvidia-docker-compose2

To Install:

    sudo apt-get install fabric=1.14.0-1

    git clone git@github.com:atlab/docker.git

    cd docker

    pip install .

`/users/example/` is a template for creating a Dockerfile, docker-compose, and fabfile.  To use, navigate to the user directory:

    cd users/example

To launch 2 jupyter notebook containers on the host `at-gpu-ex.bdc.bcm.edu` with 3 gpus per container:

    fab -H at-gpu-ex.bdc.bcm.edu deploy_atlab:n=2,gpus=3

To stop all of these jupyter notebook containers:

    fab -H at-gpu-ex.bdc.bcm.edu stop_atlab

To run 4 `hello.py` jobs on the host `at-gpu-ex.bdc.bcm.edu` with 1 gpus per container:

    fab -H at-gpu-ex.bdc.bcm.edu deploy_atlab:hello,n=4

To stop these `hello.py` jobs:

    fab -H at-gpu-ex.bdc.bcm.edu stop_atlab:hello