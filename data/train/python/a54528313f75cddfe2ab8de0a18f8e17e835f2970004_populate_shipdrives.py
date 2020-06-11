# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations


def initial_data(apps, schema_editor):
    SD = apps.get_model('ship', 'ShipDrive')
    SD(name='Nuclear Drive', speed=2).save()
    SD(name='Fusion Drive', speed=3).save()
    SD(name='Ion Drive', speed=4).save()
    SD(name='AntiMatter Drive', speed=5).save()
    SD(name='Hyper Drive', speed=6).save()
    SD(name='Interphased Drive', speed=7).save()


class Migration(migrations.Migration):

    dependencies = [
        ('ship', '0003_auto_20141004_0821'),
    ]

    operations = [
        migrations.RunPython(initial_data),
    ]
