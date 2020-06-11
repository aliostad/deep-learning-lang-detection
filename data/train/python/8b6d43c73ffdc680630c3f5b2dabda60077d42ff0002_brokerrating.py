# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('brokerhome', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='BrokerRating',
            fields=[
                ('rate_id', models.AutoField(serialize=False, primary_key=True)),
                ('rating', models.DecimalField(null=True, max_digits=10, decimal_places=2, blank=True)),
                ('review', models.CharField(max_length=1000, null=True, blank=True)),
                ('broker_id', models.ForeignKey(related_name='broker_rate', db_column=b'broker_id', to='brokerhome.BrokerDetails')),
                ('user_id', models.ForeignKey(to='brokerhome.Users', db_column=b'user_id')),
            ],
            options={
                'db_table': 'broker_rating',
            },
        ),
    ]
