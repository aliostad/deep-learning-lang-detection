# -*- coding: utf-8 -*-
#
# (c) 2016 Hareau SAS / Weenect, https://www.weenect.com
#
# This file is part of the weedi library
#
# MIT License : https://raw.githubusercontent.com/weenect/weedi/master/LICENSE.txt

import weedi.loadables_repository as loadables_repository


class ServicesRepository(loadables_repository.LoadablesRepository):
    entry_point = 'services'
    conf_section = 'services'


class MissingServicesRepository(loadables_repository.LoadablesRepository):
    entry_point = 'services.missing'
    conf_section = 'services'


class ConfigurationServicesRepository(loadables_repository.LoadablesRepository):
    entry_point = 'services.configuration'
    conf_section = 'services_configuration'


class UnpriorizedServicesRepository(loadables_repository.LoadablesRepository):
    entry_point = 'services.priority'
    conf_section = 'services'
