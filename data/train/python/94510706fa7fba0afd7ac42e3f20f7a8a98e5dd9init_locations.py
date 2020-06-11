## Initialize locations and types of objects
## MW, GPLv3+, nov 2014

import django
django.setup()

from partage_app.models import Location, Category

## Init locations
Location(name="Montrouge B").save()
Location(name="Montrouge C").save()
Location(name="Jourdan").save()
Location(name="Ulm 46").save()
Location(name="Ulm 45").save()

## Init locations
Category(name="Bricolage", color="").save()
Category(name="Cuisine", color="").save()
Category(name="Poney", color="").save()
Category(name="Autre", color="").save()
