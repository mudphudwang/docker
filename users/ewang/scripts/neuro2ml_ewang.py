#!/usr/bin/env python3

import logging
from nsearch_experiments import neuro2ml
logging.basicConfig(level=logging.INFO)

neuro2ml.Neuro2MLDataset().populate(reserve_jobs=True)