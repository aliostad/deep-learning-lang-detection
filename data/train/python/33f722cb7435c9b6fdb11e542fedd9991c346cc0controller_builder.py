#!/usr/bin/env python3
#
# Copyright 2014 Simone Campagna
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

__author__ = "Simone Campagna"

__all__ = [
    'controller_builder',
]

import numpy as np

from . import get_controller_class, get_controller_types
from ..errors import RubikError
from ..application.config import get_config

def controller_builder(logger, controller_type, data, attributes=None, attribute_files=None, title=None):
    # defaults:
    if attributes is None:
        attributes = {}
    if attribute_files is None:
        attribute_files = []

    # config instance:
    config = get_config()

    # to controller_types:
    if isinstance(controller_type, (list, tuple)):
        orig_controller_types = tuple(controller_type)
    else:
        orig_controller_types = (controller_type, )

    # auto-detect controller_type(s)
    controller_types = []
    for controller_type in orig_controller_types:
        if controller_type is None or controller_type == "auto":
            if isinstance(data, np.ndarray):
                usable_controller_types = []
                for vt in get_controller_types():
                    vc = get_controller_class(vt, logger)
                    if vc is not None and vc.DATA_CHECK(data):
                        usable_controller_types.append(vt)
                if not usable_controller_types:
                    raise RubikError("cannot find a valid controller for {} object with rank {}".format(type(data), len(data.shape)))
                if config.preferred_controller in usable_controller_types:
                    usable_controller_type = config.preferred_controller
                else:
                    usable_controller_type = usable_controller_types[0]
                if usable_controller_type is None:
                    raise RubikError("cannot find a valid controller for {} object".format(type(data)))
                controller_types.append(usable_controller_type)
        else:
            if not controller_type in get_controller_types():
                raise RubikError("invalid controller_type {!r}".format(controller_type))
            controller_types.append(controller_type)

    # get controller class:
    controller_class = None
    for controller_type in controller_types:
        controller_class = get_controller_class(controller_type, logger)
        if controller_class is not None:
            break
    else:
        raise RubikError("no usable controller")
    
    # attributes:
    controller_attributes = {}
    controller_attributes.update(config.controller_attributes.get(controller_type, {}))
    for attribute_file in attribute_files:
        controller_attributes.update(config.read_attribute_file(attribute_file))
    controller_attributes.update(dict(attributes))
    # build:
    logger.info("creating {} controller...".format(controller_class.__name__))
    return controller_class(logger=logger, shape=data.shape, attributes=controller_attributes, title=title)
