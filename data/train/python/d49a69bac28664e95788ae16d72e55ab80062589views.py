# -*- coding: utf-8 -*-

from club.models import *
from django.http import HttpResponse
from datetime import *

def index(request):
    client_list = Client.objects.all()
    output = ', '.join([c.name for c in client_list])
    return HttpResponse(output)
	
	
def init(request):

	Programm.objects.all().delete()
	Age.objects.all().delete()
	Room.objects.all().delete()
	Source.objects.all().delete()
	Client.objects.all().delete()
	Staff.objects.all().delete()

	age_1_3 = Age(age='1-3')
	age_1_3.save()
	age_4_6 = Age(age='4-6')
	age_4_6.save()
	age_unlimit = Age(age='Без ограничения')
	age_unlimit.save()
	
	room_1 = Room(name='Зал 1',floor='1 этаж',building='1')
	room_1.save()
	room_2 = Room(name='Зал 2',floor='1 этаж',building='1')
	room_2.save()
	room_3 = Room(name='Зал 3',floor='1 этаж',building='1')
	room_3.save()
	
	Source(name='Буду мамой').save()
	Source(name='Вывеска').save()
	Source(name='Галерея').save()
	Source(name='День матери').save()
	Source(name='Директор').save()
	Source(name='Знакомые').save()	
	Source(name='Друзья').save()	
	Source(name='Вконтакте').save()
	Source(name='Мероприятие').save()	
	Source(name='Партнёры узнайки').save()	
	Source(name='Узнайка').save()	
	Source(name='Сертификат').save()	
	Source(name='Реклама').save()	
	Source(name='Сайт').save()
	Source(name='Семинар для беременных').save()
	Source(name='Хеппилон').save()
	
	
	Programm(name='Смарт-спорт', age = age_unlimit).save()
	Programm(name='Танцы', age = age_unlimit).save()
	Programm(name='Йога', age = age_unlimit).save()
	Programm(name='Йога для беременных', age = age_unlimit).save()
	Programm(name='Подв. ЛФК', age = age_unlimit).save()
	Programm(name='Арт. терапия', age = age_unlimit).save()
	Programm(name='BWA', age = age_unlimit).save()
	Programm(name='BWA экспресс', age = age_unlimit).save()
	Programm(name='ОГ', age = age_unlimit).save()
	Programm(name='Фёст степ', age = age_unlimit).save()
	
	staff_Katya = Staff(first_name='Катя',trainer=False)
	staff_Katya.save()
	staff_Yulia = Staff(first_name='Юля',trainer=False)
	staff_Yulia.save()
	Staff(first_name='Наташа',trainer=False).save()
	Staff(first_name='Даша',trainer=False).save()
	Staff(first_name='Малыш',trainer=False).save()
	Staff(first_name='Ужак',trainer=False).save()
	trainer_1 = Staff(first_name='Тренер 1',trainer=True)
	trainer_1.save()
	trainer_2 = Staff(first_name='Тренер 2',trainer=True)
	trainer_2.save()
	trainer_3 = Staff(first_name='Тренер 3',trainer=True)
	trainer_3.save()
	
	Group(name='Группа 1', room = room_1, trainer = trainer_1).save()
	Group(name='Группа 2', room = room_2, trainer = trainer_1).save()
	Group(name='Группа 3', room = room_3, trainer = trainer_1).save()
	
	client_1 = Client(first_name='Виктория',mobile_phone='9120373',last_name='',manager=staff_Katya)
	client_1.save()
	
	client_1_1 = Client(first_name='Лада',last_name='',manager=staff_Katya,parent=client_1)
	client_1_1.save()
	
	Client(first_name='Виталия',mobile_phone='89217703180',last_name='',manager=staff_Yulia)
	
	
	
	return HttpResponse()
