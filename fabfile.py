from fab_docker_gpu.fdg import *


# def test():
#     return fdg.availability()

# def with_sudo():
#     """
#     Prompts and sets the sudo password for all following commands. 
    
#     Use like
    
#     fab with_sudo command
#     """
#     env.sudo_password = getpass('Please enter sudo password: ')


# def on(which, *args):
#     env.hosts = list(filter(lambda x: x not in args, getattr(env, which).split(',')))


# def excluding(*args):
#     with hide('output', 'running'):
#         env.hosts = list(filter(lambda x: x not in args, env.hosts))


# def all_machines():
#     """
#     Sets the machines on which the following commands are executed to the `machines` in `.~/fabricrc`. 
#     This overrides the `-H` argument. 
    
#     Use like
    
#     fab all_machines -P command
#     """
#     env.hosts = env.machines.split(',')


# def get_branch(gitdir):
#     """
#     Gets the branch of a git directory. 
    
#     Args:
#         gitdir: path of the git directory 

#     Returns: current active branch
        
#     """
#     with lcd(join(env.localbasedir, gitdir)):
#         branch = local('git symbolic-ref --short HEAD', capture=True)
#     return branch

# def clone_code():
#     run('mkdir -p {}'.format(env.basedir))
#     with cd(env.basedir), settings(warn_only=True):
#         for repo, url in repo_dict.items():
#             if not exists(repo):
#                 run('git clone {} {}'.format(url, repo))


# def update_git_dirs():
#     with settings(warn_only=True):
#         for gitdir in repo_dict.keys():
#             pull_code(gitdir)

# def pull_code(gitdir=None, branch=None):
#     with cd(join(env.basedir, gitdir)):
#         if branch is None:
#             branch = get_branch(gitdir)
#         run('git reset --hard')
#         run('git clean -fd')
#         run('git pull')
#         run('git checkout {}'.format(branch))
#         run('git pull origin ' + branch)


# def sync_env_file():
#     local('scp ../.env ' + env.host_string + ':' + join(env.basedir))


# def sync_data():
#     if not exists(join(env.datadir, 'tinyimagenet.zip')):
#         run('mkdir -p {}'.format(env.datadir))
#         local('scp ' + join(env.localdatadir, 'tinyimagenet.zip ')
#               + env.host_string + ':' + join(env.datadir))
#     if not exists(join(env.datadir, 'tinyimagenet')):
#         with cd(env.datadir), settings(warn_only=True):
#             run('unzip tinyimagenet.zip -d tinyimagenet')

# def sync(file):
#     local('scp ' + file + ' ' + env.host_string + ':' + join(env.basedir, 'network-search-8/'))

# def gpu_devices():
#     ret = []
#     for dev in run('ls /dev/nvidia*').split():
#         m = re.match(device_re, dev)
#         if m:
#             ret.append(m.groupdict()['device'])
#     return ret


# def free_gpu_slots():
#     with hide('output', 'running'):
#         gpus = gpu_devices()
#         containers = run('docker ps -q --no-trunc').split()
#         for container in containers:
#             host_devs = run("docker exec {} /bin/ls /dev".format(container))
#             for dev in re.findall(r'nvidia(?P<device>\d+)', host_devs):
#                 if dev in gpus:
#                     gpus.remove(dev)
#     return gpus

# def initialize():
#     clone_code()
#     update_git_dirs()
#     sync_env_file()
#     sync_data()


# def availability():
#     puts(env.host_string + ' free GPUs: ' + ','.join(free_gpu_slots()))


# def deploy(yml_file, service, n=None, rebuild=False):
#     project_dir = join(env.basedir, 'network-search-8')
#     gpus = free_gpu_slots()
#     rebuild = strtobool(str(rebuild))

#     if len(gpus) == 0:
#         puts('No free GPUs found')
#         return

#     if n is not None:
#         gpus = gpus[:int(n)]

#     initialize()

#     with cd(project_dir), shell_env(HOSTNAME=env.host_string):
#         for gpu in gpus:
#             run('nvidia-docker-compose -t {} build {} {}{}'.format(yml_file,
#                                                                    '' if not rebuild else '--no-cache',
#                                                                    service, gpu))
#             run('nvidia-docker-compose -t {} up -d {}{};'.format(yml_file, service, gpu))
#     puts('started service {} on {} on GPUs {}'.format(env.host_string, service, ' '.join(gpus)))


# def docker_login():
#     run('docker login')


# def remove_old_containers():
#     with settings(warn_only=True):
#         run('docker ps -aq| xargs docker rm')


# def containers():
#     with hide('running'):
#         ret = run("docker ps --format '{{.Names}} -> {{.ID}}'")
#     return [r.strip() for r in ret.split('\n') if '->' in r]


# ps = containers


# def stop(wildcard):
#     candidates = {k: v for k, v in map(lambda s: s.split(' -> '), containers())}
#     selection = fnmatch.filter(candidates.keys(), wildcard)
#     stop = [candidates[s] for s in selection]
#     if len(stop) > 0:
#         run('docker stop {}'.format(' '.join(stop)))


# def kill(wildcard):
#     candidates = {k: v for k, v in map(lambda s: s.split(' -> '), containers())}
#     selection = fnmatch.filter(candidates.keys(), wildcard)
#     stop = [candidates[s] for s in selection]
#     if len(stop) > 0:
#         run('docker kill {}'.format(' '.join(stop)))


# def logs(pattern, wildcard='*'):
#     candidates = {k: v for k, v in map(lambda s: s.split(' -> '), containers())}
#     selection = fnmatch.filter(candidates.keys(), wildcard)
#     candidates = [candidates[s] for s in selection]
#     for candidate in candidates:
#         run('docker logs {} | egrep "{}"'.format(candidate, pattern))
