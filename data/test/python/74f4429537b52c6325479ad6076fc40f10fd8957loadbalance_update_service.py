# -*- coding: utf-8 -*-
"""

    deployr

    created by hgschmidt on 27.11.12, 00:36 CET
    
    Copyright (c) 2012 apitrary

"""
from lb_deployr.repositories import loadbalance_update_repository

def loadbalance_update_api(api_id, api_host, api_port):
    """
        Write the backends and frontends configuration file for haproxy
        for a given deployed API.
    """
    return loadbalance_update_repository.loadbalance_update_api(
        api_id=api_id,
        api_host=api_host,
        api_port=api_port
    )