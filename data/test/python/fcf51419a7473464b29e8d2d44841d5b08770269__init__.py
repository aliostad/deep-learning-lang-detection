#!/usr/bin/env python
# -*- coding: utf-8 -*-
from dbaas_zabbix.dbaas_api import DatabaseAsAServiceApi
from dbaas_zabbix.provider_factory import ProviderFactory
from pyzabbix import ZabbixAPI


def factory_for(**kwargs):
    databaseinfra = kwargs['databaseinfra']
    credentials = kwargs['credentials']
    del kwargs['databaseinfra']
    del kwargs['credentials']

    zabbix_api = ZabbixAPI
    if kwargs.get('zabbix_api'):
        zabbix_api = kwargs.get('zabbix_api')
        del kwargs['zabbix_api']

    dbaas_api = DatabaseAsAServiceApi(databaseinfra, credentials)

    return ProviderFactory.factory(dbaas_api, zabbix_api=zabbix_api, **kwargs)
