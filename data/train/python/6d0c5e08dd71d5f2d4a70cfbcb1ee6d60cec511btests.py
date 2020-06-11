from django.test import TestCase

from goods.models import Base, Goods, Technic, Materials, Colors, Holidays, Styles

b = Base(name = 'Расческа', size = '5')
t = Technic(name = '')
m = Materials(name = '')
c = Colors(name = '')
h = Holidays(name = '', date = '')
s = Styles(name = '')
b.save()
t.save()
m.save()
c.save()
h.save()
s.save()
g = Goods(name = '',base = b,technic = c, price = 10, material = m, description = '<b>Tests Goods</b>',
	color = c, holiday = h, style = s, age = Goods.MID, consumer = Goods.MAN,count = 1)

