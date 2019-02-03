from fab_docker_gpu.fdg import *


REPO_FORK = 'mudphudwang'
REPO_BRANCH = 'master'
ENV_PATH = abspath('.env')


d = Deploy(REPO_FORK, REPO_BRANCH, ENV_PATH)

def deploy(script=None, n=10, gpus=1, token=None):
    d.deploy('atlab', script, n, gpus, token)