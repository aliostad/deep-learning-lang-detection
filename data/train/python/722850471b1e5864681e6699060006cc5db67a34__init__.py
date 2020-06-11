# -*- coding: utf-8 -*-

def init_app(app):
    from api.register import register_api
    from api.v0_2.bill import BillApi
    from api.v0_2.party import PartyApi
    from api.v0_2.person import PersonApi
    from api.v0_2.statement import StatementApi

    register_api(app, BillApi, 'bill_api_v0_2', '/v0.2/bill/', pk_type='string')
    register_api(app, PartyApi, 'party_api_v0_2', '/v0.2/party/')
    register_api(app, PersonApi, 'person_api_v0_2', '/v0.2/person/')
    register_api(app, StatementApi, 'statement_api_v0_2', '/v0.2/statement/')

