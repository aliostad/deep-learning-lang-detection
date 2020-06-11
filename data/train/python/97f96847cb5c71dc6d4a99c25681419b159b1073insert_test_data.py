# Insert some test data
# python manage.py shell < insert_test_data.py

from demo.models import Car, Part, Manufacturer

car1= Car(name='Dune Buggy')
car1.save()

car2 = Car(name='Snow Plough')
car2.save()

manufacturer1 = Manufacturer(name='Froggy')
manufacturer1.save()
manufacturer2 = Manufacturer(name='Spidey')
manufacturer2.save()

manufacturer3 = Manufacturer(name='Wintery')
manufacturer3.save()

part1 = Part(name='wheel', car=car1, manufacturer=manufacturer1)
part1.save()

part2 = Part(name='suspension', car=car1, manufacturer=manufacturer2)
part2.save()

part3 = Part(name='plough', car=car2, manufacturer=manufacturer3)
part3.save()

part4 = Part(name='tracks', car=car2, manufacturer=manufacturer1)
part4.save()

part_unused = Part(name='fairy wings', manufacturer=manufacturer2)
part_unused.save()
