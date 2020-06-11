# -*- coding: utf-8 -*-

class CryptsyApiConfig:
    """Config for cryptsy.com API services.
    Usage:
        class MyCryptsyApiConfig(CryptsyApiConfig):
            public_key = 'mypublickey'
            private_key = 'myprivatekey'
        c = CryptsyApi(MyConfig)
    """
    public_key = ''
    private_key = ''

    timeout = 60
    tries = 1

    url = 'https://api.cryptsy.com/api/v2'
    public_url = 'http://api.cryptsy.com/api/v2'

    chart_url = 'http://www.cryptsy.com/chart.php'

    old_public_url = 'http://pubapi.cryptsy.com/api.php'
    old_private_url = 'https://api.cryptsy.com/api'
