# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('comment', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='ownercomment',
            name='owner',
            field=models.ForeignKey(related_name='+', verbose_name='Owner', to='repository.Owner'),
        ),
        migrations.AlterField(
            model_name='repositorycomment',
            name='repository',
            field=models.ForeignKey(related_name='+', verbose_name='Repository', to='repository.Repository'),
        ),
    ]
