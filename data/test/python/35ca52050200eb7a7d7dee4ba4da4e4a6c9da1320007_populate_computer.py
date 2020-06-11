# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations


def initial_data(apps, schema_editor):
    SC = apps.get_model('ship', 'ShipComputer')
    SC(name='None', beamattack=0).save()
    SC(name='Electronic', beamattack=25).save()
    SC(name='Optronic', beamattack=50).save()
    SC(name='Positronic', beamattack=75).save()
    SC(name='Cybertronic', beamattack=100).save()
    SC(name='Moleculartronic', beamattack=125).save()


class Migration(migrations.Migration):

    dependencies = [
        ('ship', '0006_auto_20141004_0839'),
    ]

    operations = [
        migrations.RunPython(initial_data),
    ]
