from fab_docker_gpu.fdg import *


REPO_FORK = 'mudphudwang'
REPO_BRANCH = 'master'
ENV_PATH = '/home/ewang/nas-project/code/.env'


d = Deploy(REPO_FORK, REPO_BRANCH, ENV_PATH)

def deploy_nsearch7(script=None, n=10, gpus=1, token=None):
    d.deploy('nsearch7', script, n, gpus, token)

def stop_nsearch7(script=None):
    d.stop('nsearch7', script)

def deploy_nsearch8(script=None, n=10, gpus=1, token=None):
    d.deploy('nsearch8', script, n, gpus, token)

def stop_nsearch8(script=None):
    d.stop('nsearch8', script)

def deploy_nsearch8dev(script=None, n=10, gpus=1, token=None):
    d.deploy('nsearch8dev', script, n, gpus, token)

def stop_nsearch8dev(script=None):
    d.stop('nsearch8dev', script)