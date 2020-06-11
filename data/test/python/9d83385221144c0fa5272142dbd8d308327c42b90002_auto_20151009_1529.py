# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


def load_data(apps, schema_editor):
    Language = apps.get_model('hicks_language', 'Language')
    Language(code='ar-AE', display_name='Arabic (U.A.E.)').save()
    Language(code='az-AZ', display_name='Azeri (Latin) (Azerbaijan)').save()
    Language(code='bg-BG', display_name='Bulgarian (Bulgaria)').save()
    Language(code='ca-ES', display_name='Catalan (Spain)').save()
    Language(code='cs-CZ', display_name='Czech (Czech Republic)').save()
    Language(code='da-DK', display_name='Danish (Denmark)').save()
    Language(code='de-AT', display_name='German (Austria)').save()
    Language(code='de-CH', display_name='German (Switzerland)').save()
    Language(code='de-DE', display_name='German (Germany)').save()
    Language(code='el-GR', display_name='Greek (Greece)').save()
    Language(code='en-US', display_name='English (United States)').save()
    Language(code='es-ES', display_name='Spanish (Spain)').save()
    Language(code='es-MX', display_name='Spanish (Mexico)').save()
    Language(code='et-EE', display_name='Estonian (Estonia)').save()
    Language(code='fi-FI', display_name='Finnish (Finland)').save()
    Language(code='fr-BE', display_name='French (Belgium)').save()
    Language(code='fr-CH', display_name='French (Switzerland)').save()
    Language(code='fr-FR', display_name='French (France)').save()
    Language(code='hr-HR', display_name='Croatian (Croatia)').save()
    Language(code='hu-HU', display_name='Hungarian (Hungary)').save()
    Language(code='id-ID', display_name='Indonesian (Indonesia)').save()
    Language(code='it-CH', display_name='Italian (Switzerland)').save()
    Language(code='it-IT', display_name='Italian (Italy)').save()
    Language(code='ja-JP', display_name='Japanese (Japan)').save()
    Language(code='ko-KR', display_name='Korean (Korea)').save()
    Language(code='lt-LT', display_name='Lithuanian (Lithuania)').save()
    Language(code='lv-LV', display_name='Latvian (Latvia)').save()
    Language(code='ms-MY', display_name='Malay (Malaysia)').save()
    Language(code='nb-NO', display_name='Norwegian (Bokmål) (Norway)').save()
    Language(code='nl-BE', display_name='Dutch (Belgium)').save()
    Language(code='nl-NL', display_name='Dutch (Netherlands)').save()
    Language(code='pl-PL', display_name='Polish (Poland)').save()
    Language(code='pt-BR', display_name='Portuguese (Brazil)').save()
    Language(code='pt-PT', display_name='Portuguese (Portugal)').save()
    Language(code='ro-RO', display_name='Romanian (Romania)').save()
    Language(code='ru-RU', display_name='Russian (Russia)').save()
    Language(code='sk-SK', display_name='Slovak (Slovakia)').save()
    Language(code='sv-SE', display_name='Swedish (Sweden)').save()
    Language(code='th-TH', display_name='Thai (Thailand)').save()
    Language(code='tl-PH', display_name='Tagalog (Philippines)').save()
    Language(code='tr-TR', display_name='Turkish (Turkey)').save()
    Language(code='uk-UA', display_name='Ukrainian (Ukraine)').save()
    Language(code='vi-VN', display_name='Vietnamese (Viet Nam)').save()
    Language(code='zh-CN', display_name='Chinese (China)').save()
    Language(code='zh-HK', display_name='Chinese (Hong Kong)').save()
    Language(code='zh-SG', display_name='Chinese (Singapore)').save()
    Language(code='zh-TW', display_name='Chinese (Taiwan)').save()


class Migration(migrations.Migration):
    dependencies = [
        ('hicks_language', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(load_data)
    ]
