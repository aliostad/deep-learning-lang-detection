from django.conf.urls.defaults import patterns

from moca.mrs import api_handlers

urlpatterns = patterns(
    '',

    (r'^status/$',
     api_handlers.status_resource,
     {},
     'moca-api-status'),

    (r'^notification/(?P<notification_id>\d+)$',
     api_handlers.notification_resource,
     {},
     'moca-api-notification-by-id'),

    (r'^notification/$',
     api_handlers.notification_resource,
     {},
     'moca-api-notification'),

    (r'^patient/(?P<patient_id>[\d-]+)$',
     api_handlers.patient_resource,
     {},
     'moca-api-patient-by-id'),

    (r'^patient/$',
     api_handlers.patient_resource,
     {},
     'moca-api-patient'),

    (r'^roles/$',
     api_handlers.roles_resource,
     {},
     'moca-api-roles'),

    (r'^locations/$',
     api_handlers.locations_resource,
     {},
     'moca-api-locations'),

    (r'^procedure/(?P<procedure_id>\d+)$',
     api_handlers.procedure_resource,
     {},
     'moca-api-procedure-by-id'),

    (r'^procedure/$',
     api_handlers.procedure_resource,
     {},
     'moca-api-procedure'),

    (r'^case/(?P<case_id>\d+)$',
     api_handlers.case_resource,
     {},
     'moca-api-case-by-id'),

    (r'^case/$',
     api_handlers.case_resource,
     {},
     'moca-api-case'),

    (r'^binary/$',
     api_handlers.binary_resource,
     {},
     'moca-api-binary'),

    (r'^text/$',
     api_handlers.text_resource,
     {},
     'moca-api-text'),
)
