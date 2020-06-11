# -*- coding: utf-8 -*-
#
# Copyright (c) 2013 Daniele Valeriani (daniele@dvaleriani.net).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Note: it only returns the first physical drive of a logical drive

'''
Module for managing storage controllers on POSIX-like systems.
'''
from salt.utils.decorators import depends

# Detect the controller from a list of supported models
models = {
    '10000079': 'perc8xx',
    '1000005b': 'perc8xx',
    '13c11004': 'lsi3ware'
}

with open('/proc/bus/pci/devices', 'r') as f:
    lines = f.readlines()
for line in lines:
    pci_id = line.split('\t')[1]
    if models.has_key(pci_id):
        model = models[pci_id]
        break

try:
    controller = getattr(__import__('storage_controllers.controllers',
                                    fromlist=[model]), model)
except ImportError:
    pass


def _fallback():
    return 'The storage-controllers module needs to be installed or missing ' \
           'controller plugin'

@depends('controller', fallback_function=_fallback)
def logical_drive(controller_id, logical_drive_id=None):
    """
    Provides information about logical drives.
    Returns only one logical drive if specified, otherwise returns information
    for all the logical drives of the specified controller.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.logical_drive <controller id>
        salt '*' controller.logical_drive <controller id> <logical drive id>
    """
    if logical_drive_id is None:
        try:
            ctl = controller.Controller(controller_id)
            info = [l.get_info() for l in ctl.get_logical_drives()]
            return info
        except:
            return {"controller": controller_id,
                    "status": "Failed to retrieve information"}
    else:
        try:
            ld = controller.LogicalDrive(controller_id, logical_drive_id)
            info = ld.get_info()
            return info
        except:
            return {"controller": controller_id,
                    "logical_drive": logical_drive_id,
                    "status": "Failed to retrieve information"}

@depends('controller', fallback_function=_fallback)
def logical_drive_by_name(device_name):
    """
    Try to extract information for a logical drive given the device name.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.logical_drive_by_name <device name>
    """
    try:
        info = controller.get_logical_drive(device_name).get_info()
        return info
    except:
        return {"logical_drive": device_name,
                "status": "Failed to retrieve information"}

@depends('controller', fallback_function=_fallback)
def logical_drive_delete(controller_id, logical_drive_id):
    """
    Delete a logical drive.
    Returns the information for the logical drive that just got deleted.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.logical_drive_delete <controller id> <logical drive id>
    """
    try:
        ld = controller.LogicalDrive(controller_id, logical_drive_id)
        info = ld.get_info()
        x = ld.delete()
        return dict(x)
    except:
        return {"controller": controller_id,
                "logical_drive": logical_drive_id,
                "status": "Failed to delete"}

@depends('controller', fallback_function=_fallback)
def logical_drive_create(controller_id, physical_drive_id):
    """
    Create a logical drive.
    Returns the information for the logical drive that just got created.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.logical_drive_create <controller id> <physical drive>
    """
    try:
        ctl = controller.Controller(controller_id)
        info = ctl.create_logical_drive(physical_drive_id)
        return info
    except:
        return {"controller": controller_id,
                "physical_drive": physical_drive_id,
                "status": "Failed to create a logical drive"}

@depends('controller', fallback_function=_fallback)
def physical_drive(controller_id, physical_drive_id=None):
    """
    Provides information about physical drives.
    Returns only one physical drive if specified, otherwise returns information
    for all the physical drives of the specified controller.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.physical_drive <controller id>
        salt '*' controller.physical_drive <controller id> <physical drive id>
    """
    if physical_drive_id is None:
        try:
            ctl = controller.Controller(controller_id)
            return [p.get_info() for p in ctl.get_physical_drives()]
        except:
            return {"controller": controller_id,
                    "status": "Failed to get information for physical drives"}
    else:
        try:
            phy_drv = controller.get_physical_drive(controller_id,
                                                    physical_drive_id)
            return phy_drv.get_info()
        except:
            return {"controller": controller_id,
                    "physical_drive": physical_drive_id,
                    "status": "Not present"}

@depends('controller', fallback_function=_fallback)
def info(controller_id=None):
    """
    Provides information about the storage controllers.
    Returns only one controller if specified, otherwise returns information
    for all the controllers on the server.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.info
        salt '*' controller.info <controller id>
    """
    if controller_id is None:
        try:
            return [c.get_info() for c in controller.get_controllers()]
        except:
            return {"status": "Failed to get controllers information"}
    else:
        try:
            return controller.Controller(controller_id).get_info()
        except:
            return {"controller": controller_id,
                    "status": "Failed to get controller information"}

@depends('controller', fallback_function=_fallback)
def blink_led(controller_id, physical_drive_id):
    """
    Switch on the indicator led for the specified port.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.blink_led <controller id> <physical_drive_id>
    """
    try:
        phy_drv = controller.get_physical_drive(controller_id, physical_drive_id)
        return phy_drv.blink_led()
    except:
        return {"controller": controller_id,
                "physical_drive": physical_drive_id,
                "status": "Failed to blink the led"}

@depends('controller', fallback_function=_fallback)
def unblink_led(controller_id, physical_drive_id):
    """
    Switch off the indicator led for the specified port.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.unblink_led <controller id> <physical_drive_id>
    """
    try:
        phy_drv = controller.get_physical_drive(controller_id, physical_drive_id)
        return phy_drv.unblink_led()
    except:
        return {"controller": controller_id,
                "physical_drive": physical_drive_id,
                "status": "Failed to unblink the led"}

@depends('controller', fallback_function=_fallback)
def clear_foreign_config(controller_id):
    """
    Clear the foreign config.

    CLI Example:

    .. code-block:: bash

        salt '*' controller.clear_foreign_config <controller id>
    """
    try:
        return controller.Controller(controller_id).clear_foreign_config()
    except:
        return {"controller": controller_id,
                "status": "Failed to clear the foreign config"}
