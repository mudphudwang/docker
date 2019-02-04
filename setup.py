#!/usr/bin/env python
from setuptools import setup, find_packages
from os import path

here = path.abspath(path.dirname(__file__))

setup(
    name='fab-docker-gpu',
    version='0.0',
    description='GPU managment for docker-compose',
    author='Eric Y. Wang',
    author_email='eric.wang2@bcm.edu',
    packages=find_packages(exclude=[]),
    install_requires=['numpy>=1.15'],
)
