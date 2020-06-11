# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.apps import apps as real_apps
from django.db import migrations, models, transaction

MANAGE_PEOPLE_ROLE_DATA = [
    # NOTE: this data does not need to vary between environments, as the ids
    #       in the user_role table are the same in both qa and prod oracle
    # (user_role_id, canvas_role_label, xid_allowed)
    (0, 'StudentEnrollment', False),
    (1, 'Course Head', False),
    (2, 'Faculty', False),
    (5, 'TaEnrollment', False),
    (7, 'DesignerEnrollment', False),
    (9, 'TeacherEnrollment', False),
    (10, 'Guest', True),
    (11, 'Course Support Staff', False),
    (12, 'Teaching Staff', False),
    (15, 'ObserverEnrollment', False)
]
LTI_PERMISSIONS_DATA = [
    ('manage_people', '*', 'Account Observer', True),
    ('manage_people', '*', 'AccountAdmin', True),
    ('manage_people', '*', 'Account Admin', True),
    ('manage_people', '*', 'Course Head', True),
    ('manage_people', '*', 'Course Support Staff', True),
    ('manage_people', '*', 'Department Admin', True),
    ('manage_people', '*', 'DesignerEnrollment', True),
    ('manage_people', '*', 'Faculty', True),
    ('manage_people', '*', 'Guest', False),
    ('manage_people', '*', 'Help Desk', True),
    ('manage_people', '*', 'Librarian', True),
    ('manage_people', '*', 'ObserverEnrollment', False),
    ('manage_people', '*', 'SchoolLiaison', True),
    ('manage_people', '*', 'StudentEnrollment', False),
    ('manage_people', '*', 'TaEnrollment', True),
    ('manage_people', '*', 'TeacherEnrollment', True),
    ('manage_people', '*', 'Teaching Staff', True),
    ('manage_people', 'gse', 'Help Desk', False),
    ('manage_people', 'hks', 'Course Head', False),
    ('manage_people', 'hks', 'Course Support Staff', False),
    ('manage_people', 'hks', 'DesignerEnrollment', False),
    ('manage_people', 'hks', 'Librarian', False),
    ('manage_people', 'hks', 'TaEnrollment', False),
    ('manage_people', 'hks', 'Teaching Staff', False),
    ('manage_people', 'hls', 'Account Observer', False),
    ('manage_people', 'hls', 'Course Head',  False),
    ('manage_people', 'hls', 'Course Support Staff', False),
    ('manage_people', 'hls', 'Department Admin', False),
    ('manage_people', 'hls', 'DesignerEnrollment', False),
    ('manage_people', 'hls', 'Faculty', False),
    ('manage_people', 'hls', 'Help Desk', False),
    ('manage_people', 'hls', 'Librarian', False),
    ('manage_people', 'hls', 'TaEnrollment', False),
    ('manage_people', 'hls', 'TeacherEnrollment', False),
    ('manage_people', 'hls', 'Teaching Staff', False)
]


def populate_manage_people_role(apps, schema_editor):
    ManagePeopleRole = apps.get_model('manage_people', 'ManagePeopleRole')
    fields = ('user_role_id', 'canvas_role_label', 'xid_allowed')
    with transaction.atomic():  # wrap all the inserts in a transaction
        for values in MANAGE_PEOPLE_ROLE_DATA:
            ManagePeopleRole.objects.create(**dict(zip(fields, values)))


def create_lti_permissions(apps, schema_editor):
    LtiPermission = apps.get_model('lti_permissions', 'LtiPermission')
    fields = ('permission', 'school_id', 'canvas_role', 'allow')

    for permission in LTI_PERMISSIONS_DATA:
        LtiPermission.objects.create(**dict(zip(fields, permission)))


def reverse_permissions_load(apps, schema_editor):
    LtiPermission = apps.get_model('lti_permissions', 'LtiPermission')
    LtiPermission.objects.filter(permission='manage_people').delete()


def reverse_manage_people_role_load(apps, schema_editor):
    ManagePeopleRole = apps.get_model('manage_people', 'ManagePeopleRole')
    ManagePeopleRole.objects.all().delete()


class Migration(migrations.Migration):

    dependencies = []

    operations = [
        migrations.CreateModel(
            name='ManagePeopleRole',
            fields=[
                ('user_role_id', models.IntegerField(primary_key=True)),
                ('canvas_role_label', models.CharField(unique=True, null=True,
                                                       max_length=30)),
                ('xid_allowed', models.BooleanField(default=False)),
            ],
            options={
                'db_table': 'manage_people_role',
            },
        ),
        migrations.RunPython(
            code=populate_manage_people_role,
            reverse_code=reverse_manage_people_role_load,
        )
    ]

    # tlt-2650: we need to check whether lti_permissions is part of
    # INSTALLED_APPS and skip the LtiPermission migration if the LtiPermission
    # model is not available.
    if real_apps.is_installed('lti_permissions'):
        dependencies.append(('lti_permissions', '0001_initial'))
        operations.insert(0,
            migrations.RunPython(
              code=create_lti_permissions,
              reverse_code=reverse_permissions_load,
            )
        )
