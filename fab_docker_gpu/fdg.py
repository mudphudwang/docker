from fabric.state import env
import fnmatch
from distutils.util import strtobool

from fabric.api import local, abort, run, sudo
from fabric.context_managers import cd, settings, hide, shell_env, lcd
import re
from os.path import join, realpath, dirname, basename, abspath
from getpass import getpass
from fabric.contrib.files import exists
from fabric.operations import put
from fabric.utils import puts
import numpy as np
import inspect

device_re = r'/dev/nvidia(?P<device>\d+)'


def with_sudo():
    """
    Prompts and sets the sudo password for all following commands. 

    Use like

    fab with_sudo command
    """
    env.sudo_password = getpass('Please enter sudo password: ')


def on(which, *args):
    env.hosts = list(filter(lambda x: x not in args, getattr(env, which).split(',')))


def excluding(*args):
    with hide('output', 'running'):
        env.hosts = list(filter(lambda x: x not in args, env.hosts))


def all_machines():
    """
    Sets the machines on which the following commands are executed to the `machines` in `.~/fabricrc`. 
    This overrides the `-H` argument. 

    Use like

    fab all_machines -P command
    """
    env.hosts = env.machines.split(',')


def get_branch(gitdir):
    """
    Gets the branch of a git directory. 

    Args:
        gitdir: path of the git directory 

    Returns: current active branch

    """
    with lcd(join(env.localbasedir, gitdir)):
        branch = local('git symbolic-ref --short HEAD', capture=True)
    return branch


def gpu_devices():
    ret = []
    for dev in run('ls /dev/nvidia*').split():
        m = re.match(device_re, dev)
        if m:
            ret.append(m.groupdict()['device'])
    return ret


def free_gpu_slots():
    with hide('output', 'running'):
        gpus = gpu_devices()
        containers = run('docker ps -q --no-trunc').split()
        for container in containers:
            host_devs = run("docker exec {} /bin/ls /dev".format(container))
            for dev in re.findall(r'nvidia(?P<device>\d+)', host_devs):
                if dev in gpus:
                    gpus.remove(dev)
    return gpus


def availability():
    puts(env.host_string + ' free GPUs: ' + ','.join(free_gpu_slots()))


def docker_login():
    run('docker login')


def remove_old_containers():
    with settings(warn_only=True):
        run('docker ps -aq| xargs docker rm')


def remove_old_images():
    with settings(warn_only=True):
        run('docker image prune -f')


def clean():
    remove_old_containers()
    remove_old_images()


def containers():
    with hide('running'):
        ret = run("docker ps --format '{{.Names}} -> {{.ID}}'")
    return [r.strip() for r in ret.split('\n') if '->' in r]


ps = containers


def stop(wildcard):
    candidates = {k: v for k, v in map(lambda s: s.split(' -> '), containers())}
    selection = fnmatch.filter(candidates.keys(), wildcard)
    stop = [candidates[s] for s in selection]
    if len(stop) > 0:
        run('docker stop {}'.format(' '.join(stop)))


def kill(wildcard):
    candidates = {k: v for k, v in map(lambda s: s.split(' -> '), containers())}
    selection = fnmatch.filter(candidates.keys(), wildcard)
    stop = [candidates[s] for s in selection]
    if len(stop) > 0:
        run('docker kill {}'.format(' '.join(stop)))


def logs(pattern, wildcard='*'):
    candidates = {k: v for k, v in map(lambda s: s.split(' -> '), containers())}
    selection = fnmatch.filter(candidates.keys(), wildcard)
    candidates = [candidates[s] for s in selection]
    for candidate in candidates:
        run('docker logs {} | egrep "{}"'.format(candidate, pattern))


class Deploy():

    def __init__(self, repo_fork='atlab', repo_branch='master', env_path=None):
        self.basedir = join('/home', env.user, 'deploy')
        self.user = basename(dirname(abspath((inspect.stack()[1])[1])))
        self.userdir = join(self.basedir, 'docker', 'users', self.user)
        self.repo_fork = repo_fork
        self.repo_branch = repo_branch
        self.env_path = env_path

    def initialize(self):
        if exists(join(self.basedir, 'docker')):
            with cd(join(self.basedir, 'docker')):
                run('git remote set-url origin https://github.com/{}/docker.git'.format(self.repo_fork))
                run('git pull origin {}'.format(self.repo_branch))
                run('git checkout {}'.format(self.repo_branch))
                run('git reset --hard origin/{}'.format(self.repo_branch))
                run('git clean -fd')
        else:
            run('mkdir -p {}'.format(self.basedir))
            with cd(self.basedir):
                run('git clone git@github.com:{}/docker.git -b {} --single-branch'.format(
                    self.repo_fork, self.repo_branch))
        if self.env_path is not None:
            local('scp ' + self.env_path + ' ' + env.host_string + ':' + self.basedir)

    def deploy(self, service, script=None, n=10, gpus=1, token=None):
        gpus = int(gpus)
        n = int(n)
        free_gpus = sorted(free_gpu_slots())

        self.initialize()
        with cd(self.userdir):
            run('docker-compose build --no-cache --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" {}'.format(service))
            bare_run_str = 'docker-compose run -d'

            gpu_i = 0
            container_i = 0
            gpu_groups = []
            while gpu_i < len(free_gpus):
                gpu_j = gpu_i + gpus
                gpu_ids = free_gpus[gpu_i: gpu_j]

                if len(gpu_ids) < gpus or container_i >= n:
                    break

                name = self.user + '_' + service + '_{script}_' + '_'.join(gpu_ids)
                args = ' -e NVIDIA_VISIBLE_DEVICES={}'.format(','.join(gpu_ids))
                gpu_run_str = bare_run_str + args

                if script is None:
                    name = name.format(script='notebook')
                    args = '-p 444{}:8888'.format(gpu_ids[0])
                    if token is not None:
                        args += ' --NotebookApp.token={}'.format(token)
                else:
                    name = name.format(script=script)
                    args = ' -v {}:/scripts'.format(join(self.userdir, 'scripts'))
                    args += ' --entrypoint "python3 /scripts/{}.py"'.format(script)

                run('(docker ps -a | grep {name}) && docker rm {name}'.format(name=name),
                    warn_only=True)
                run('{} {} --name {} {}'.format(gpu_run_str, args, name, service))

                gpu_i = gpu_j
                container_i += 1

                gpu_groups.append(','.join(gpu_ids))

        remove_old_images()
        puts('started service {} on {} on GPUs {}'.format(env.host_string, service, ' '.join(gpu_groups)))

    def stop(self, service, script=None):
        wildcard = self.user + '_' + service + '_{script}'
        wildcard = wildcard.format(script='notebook' if script is None else script)
        stop('{}*'.format(wildcard))