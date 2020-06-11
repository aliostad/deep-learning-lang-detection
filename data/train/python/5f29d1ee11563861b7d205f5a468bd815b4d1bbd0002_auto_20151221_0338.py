# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('basic_cms', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='page',
            options={'ordering': ['tree_id', 'lft'], 'get_latest_by': 'publication_date', 'verbose_name': 'page', 'verbose_name_plural': 'pages', 'permissions': [('can_freeze', 'Can freeze page'), ('can_publish', 'Can publish page'), ('can_manage_en_gb', 'Manage Base'), ('can_manage_en', 'Manage English')]},
        ),
    ]
