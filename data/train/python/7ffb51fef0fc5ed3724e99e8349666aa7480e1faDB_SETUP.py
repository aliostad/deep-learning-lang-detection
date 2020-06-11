#full path too djangoproject root
djangoproject_root = "/home/Ellis/CMPT470-1131-g-team-lazy/kotw/"

import sys,os
sys.path.append(djangoproject_root)
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'

from buildings.models import Building
from governments.models import Government, effects
from military.models import Military
from techs.models import Tech

b=Building()
b.type="enterprise"
b.effect_name="increase income"
b.effect_val=0.6
b.save()

b=Building()
b.type="residence"
b.effect_name="increase max population"
b.effect_val=100.00
b.save()

b=Building()
b.type="industrial"
b.effect_name="decrease military training costs"
b.effect_val=0.65
b.save()

b=Building()
b.type="military_base"
b.effect_name="increase military effectiveness"
b.effect_val=0.30
b.save()

b=Building()
b.type="research_lab"
b.effect_name="decrease tech costs"
b.effect_val=0.70
b.save()

b=Building()
b.type="farm"
b.effect_name="produce food"
b.effect_val=200.00
b.save()

b=Building()
b.type="oil_rig"
b.effect_name="produce oil"
b.effect_val=75.00
b.save()

b=Building()
b.type="unused"
b.effect_name="small increase to food and population"
b.effect_val=50
b.save()

print "Completed adding Buildings"

g=Government()
g.type="Monarchy"
g.save()
e=effects()
e.government=g
e.effect_name="free revolution"
e.effect_val=0
e.save()

g=Government()
g.type="Fascism"
g.save()
e=effects()
e.government=g
e.effect_name="increase resource production"
e.effect_val=1.20
e.save()
e=effects()
e.government=g
e.effect_name="decrease population"
e.effect_val=0.8
e.save()

g=Government()
g.type="Dictator"
g.save()
e=effects()
e.government=g
e.effect_name="increase military effectiveness"
e.effect_val=1.3
e.save()
e=effects()
e.government=g
e.effect_name="increase construction costs"
e.effect_val=1.20
e.save()

g=Government()
g.type="Communism"
g.save()
e=effects()
e.government=g
e.effect_name="decrease training costs"
e.effect_val=0.6
e.save()
e=effects()
e.government=g
e.effect_name="decrease income"
e.effect_val=0.8
e.save()

g=Government()
g.type="Theocracy"
g.save()
e=effects()
e.government=g
e.effect_name="decrease construction costs"
e.effect_val=0.7
e.save()
e=effects()
e.government=g
e.effect_name="decrease technology effectiveness"
e.effect_val=0.7
e.save()

g=Government()
g.type="Republic"
g.save()
e=effects()
e.government=g
e.effect_name="increase income"
e.effect_val=1.2
e.save()
e=effects()
e.government=g
e.effect_name="decrease military effectiveness"
e.effect_val=0.7
e.save()

g=Government()
g.type="Democracy"
g.save()
e=effects()
e.government=g
e.effect_name="increase technology effectiveness"
e.effect_val=1.4
e.save()
e=effects()
e.government=g
e.effect_name="decrease resource production"
e.effect_val=0.8
e.save()

print "Completed adding Governments"

m=Military()
m.unit="Troops"
m.offense=1
m.defense=1
m.fuel=0
m.save()

m=Military()
m.unit="Jets"
m.offense=4
m.defense=0
m.fuel=2
m.save()

m=Military()
m.unit="Turrets"
m.offense=0
m.defense=4
m.fuel=0
m.save()

m=Military()
m.unit="Tanks"
m.offense=6
m.defense=8
m.fuel=4
m.save()

print "Completed adding Military Units"

t=Tech()
t.type="Military"
t.effect_name="decrease military costs"
t.effect_val=0.20
t.save()

t=Tech()
t.type="Medical"
t.effect_name="reduce loss of life"
t.effect_val=0.50
t.save()

t=Tech()
t.type="Economics"
t.effect_name="increase income"
t.effect_val=0.20
t.save()

t=Tech()
t.type="Residential"
t.effect_name="increase population"
t.effect_val=0.30
t.save()

t=Tech()
t.type="Geography"
t.effect_name="increase resource production"
t.effect_val=0.50
t.save()

t=Tech()
t.type="Weapons"
t.effect_name="increase military effectiveness"
t.effect_val=0.15
t.save()

print "Completed adding Techs"