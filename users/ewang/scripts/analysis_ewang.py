#!/usr/bin/env python3

import logging
from nsearch_experiments import configs as co
from nsearch_experiments import models as mo
from nsearch_experiments import analysis as an
logging.basicConfig(level=logging.INFO)

an.Score().populate(reserve_jobs=True)