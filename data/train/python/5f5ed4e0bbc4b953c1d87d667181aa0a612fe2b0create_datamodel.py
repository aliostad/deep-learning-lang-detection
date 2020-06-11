#!/usr/bin/python

from vehicles import models

owner1 = models.Owner(name="owner1")
owner1.save()
owner2 = models.Owner(name="owner2")
owner2.save()
owner3 = models.Owner(name="owner3")
owner3.save()


car1 = models.Car(license_plate="car1", owner=owner1)
car1.save()
car2 = models.Car(license_plate="car2", owner=owner2)
car2.save()
car3 = models.Car(license_plate="car3", owner=owner3)
car3.save()
car4 = models.Car(license_plate="car4", owner=owner1)
car4.save()

moto1 = models.Motorcycle(license_plate="moto1", owner=owner2)
moto1.save()
moto2 = models.Motorcycle(license_plate="moto2", owner=owner2)
moto2.save()

trailer1 = models.Trailer(
        license_plate="trailer1",
        car=car2,
        weight=1000.12)
trailer1.save()

trailer2 = models.Trailer(
        license_plate="trailer2",
        car=car2,
        weight=1200.12)
trailer2.save()

trailer3 = models.Trailer(
        license_plate="trailer3",
        car=car1,
        weight=1100.12)
trailer3.save()
