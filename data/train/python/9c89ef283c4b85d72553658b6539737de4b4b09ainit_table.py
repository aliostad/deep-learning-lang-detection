from django.core.management.base import NoArgsCommand
from patients.models import ChemotherapySchema, Cie10
import os
import csv

class Command(NoArgsCommand):
    help = "Initialize attributes"
    def handle_noargs(self, **options):
        # No enum types
        # Chemotherapy Schemas
        ChemotherapySchema(title='Capecitabina 2gr', risk=0).save()
        ChemotherapySchema(title='Cisplatino/pemetrexed', risk=0).save()
        ChemotherapySchema(title='Dacarbazina', risk=0).save()
        ChemotherapySchema(title='Docetaxel semanal', risk=0).save()
        ChemotherapySchema(title='Folfiri', risk=0).save()
        ChemotherapySchema(title='Gemcitabina 1gr', risk=0).save()
        ChemotherapySchema(title='Gemcitabina 1.25gr', risk=0).save()
        ChemotherapySchema(title='Paclitaxel semanal', risk=0).save()
        ChemotherapySchema(title='Pemetrexed', risk=0).save()

        ChemotherapySchema(title='Capecitabina 2.5gr', risk=1).save()
        ChemotherapySchema(title='Carboplatino/gemcitabina AUC 4-6 1gr d 1 y 8', risk=1).save()
        ChemotherapySchema(title='Carboplatino/pemetrexed', risk=1).save()
        ChemotherapySchema(title='Carboplatino/paclitaxel c/ 3 sem', risk=1).save()
        ChemotherapySchema(title='Cisplatino/ gemcitabina d 1 y 8', risk=1).save()
        ChemotherapySchema(title='ECF', risk=1).save()
        ChemotherapySchema(title='Folfox 85 mg', risk=1).save()
        ChemotherapySchema(title='Gemcitabina/irinotecan', risk=1).save()
        ChemotherapySchema(title='Doxorrubicina liposomal 50 mg c/4 sem', risk=1).save()
        ChemotherapySchema(title='Topotecan semanal', risk=1).save()
        ChemotherapySchema(title='Xelox', risk=1).save()


        ChemotherapySchema(title='5fu/leucovorina (Roswell-park)', risk=2).save()
        ChemotherapySchema(title='5fu/leucovorina(Mayo)', risk=2).save()
        ChemotherapySchema(title='5-fu/lv + bevacizumab', risk=2).save()
        ChemotherapySchema(title='CAF', risk=2).save()
        ChemotherapySchema(title='Carboplatino/docetaxel 75 / 75', risk=2).save()
        ChemotherapySchema(title='Cisplatino/etoposido', risk=2).save()
        ChemotherapySchema(title='Cisplatino/gemcitabina D 1,8 y 15', risk=2).save()
        ChemotherapySchema(title='Cisplatino/paclitaxel 135- 24hs c/3 sem', risk=2).save()
        ChemotherapySchema(title='CMF clasico', risk=2).save()
        ChemotherapySchema(title='Doxorrubicina c/3 sem', risk=2).save()
        ChemotherapySchema(title='Folfox 100/30', risk=2).save()
        ChemotherapySchema(title='Gemcitabina/pemetrexed', risk=2).save()
        ChemotherapySchema(title='Irinotecan cada 3 semanas', risk=2).save()
        ChemotherapySchema(title='Paclitaxel cada 3 semanas', risk=2).save()
        ChemotherapySchema(title='Docetaxel cada 3 semanas', risk=2).save()
        ChemotherapySchema(title='Topotecan semanal', risk=2).save()

        from django.contrib.auth.models import Group, Permission
        medic = Group(name="Medic")
        medic.save()
        medic.permissions.add(Permission.objects.get(codename='add_patient'))
        medic.permissions.add(Permission.objects.get(codename='change_patient'))
        medic.permissions.add(Permission.objects.get(codename='delete_patient'))
        medic.permissions.add(Permission.objects.get(codename='add_medicalinterview'))
        medic.permissions.add(Permission.objects.get(codename='change_medicalinterview'))
        medic.permissions.add(Permission.objects.get(codename='delete_medicalinterview'))
        medic.save()

        directory = os.path.dirname(os.path.abspath(__file__))
        resoureces_dir = os.path.join(directory,'..', '..', 'resources', 'CSV_CIE10.csv')
        with open(resoureces_dir, 'r') as inputfile:
            data = csv.reader(inputfile, delimiter=',')
            #dont use head
            data.next()
            for line in data:
                if line[0].startswith("C") or line[0].startswith("D"):
                    Cie10(value=line[0]).save()
