#!/usr/bin/env python3

import logging
import numpy as np
from nsearch_experiments import configs as co
from nsearch_experiments import models as mo
logging.basicConfig(level=logging.INFO)

recurr_nets = (co.NetworkConfig.NeuroPath * co.Seed
               & co.CoreConfig.StackedDAGPathRecurrent).proj()
recurr_nets = recurr_nets & 'seed=0'


ml_nets = (co.NetworkConfig.MLPath * co.Seed).proj()
ml_nets = ml_nets

restr = (recurr_nets + ml_nets)

mo.Model().populate(
    restr,
    suppress_errors=True, reserve_jobs=True)
