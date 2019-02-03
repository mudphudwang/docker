from fab_docker_gpu.fdg import *


REPO_FORK = 'mudphudwang'
REPO_BRANCH = 'master'

def test_build():
    run('docker build -t test /home/ewang/nas-project/code/docker/configs/example/ --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"')

deploy = Deploy(REPO_FORK, REPO_BRANCH)

def testing():
    deploy.clone_deploy_repo()
    # print(deploy.basedir)