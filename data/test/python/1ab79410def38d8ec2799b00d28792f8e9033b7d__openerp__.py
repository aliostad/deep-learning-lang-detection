# -*- coding: utf-8 -*-
##############################################################################
#
#    Copyright (C) 2014-Today
#    CyG xxxx
#    @autor: Edison Guachamin <edison.guachamin@gmail.com>
#
##############################################################################
{
    "name": "CYG-Broker",
    "version": "1.0",
    "author": "CyG",
    "website": "http://www.cyg.ec",
    "category": "Sales",
    "sequence": 1,
    "complexity": "expert",
    "description": """
    Módulo de Broker
    """,
    "shortdesc": "Broker - CyG",
    "depends": [
        'base',
        'cyg_base',
        'base_ec_dpa',
        'base_ec_ruc',
        'web_m2x_options',
        ],
    "init_xml": [
                 'data/ir_sequence.xml',
                 'data/data.xml',
                 
                 ],
    "demo_xml": [],
    "update_xml": [
        'security/groups.xml',
        'views/res_partner_view.xml',
        'views/cyg_base_view.xml',
        'views/cyg_broker_view.xml',
        'views/cyg_broker_payment_view.xml',
        'views/menu_view.xml',
        ],
    "application": True,
    "auto_install": False,
}
