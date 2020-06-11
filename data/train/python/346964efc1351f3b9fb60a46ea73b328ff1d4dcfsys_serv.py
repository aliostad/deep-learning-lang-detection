

from app_factory                            import *

sys_serv, async_app                         =   celery_apps_factory(
                                                app_type                    =   'SUBSCRIBER',
                                                sync_broker_url             =   BROKER_URL,
                                                async_broker_url            =   None,
                                                backend                     =   'redis',
                                                service_name                =   'sys_serv',
                                                )

from sys_serv_tasks                          import *