from insights.configs import settings

#Account
account_products = settings.api_resources.get('account', 'account_products')

#Group
group_api = settings.api_resources.get('group', 'group_v1')

#Subset
subset_api = settings.api_resources.get('subset', 'subset_v1')

#System
system_api = settings.api_resources.get('system', 'system_v1')
system_api_v2 = settings.api_resources.get('system', 'system_v2')

#Report
report_api = settings.api_resources.get('report', 'report_v1')
report_api_v2 = settings.api_resources.get('report', 'report_v2')

#Upload
upload_api = settings.api_resources.get('upload', 'upload_v1')

#User
me = settings.api_resources.get('user', 'me')
