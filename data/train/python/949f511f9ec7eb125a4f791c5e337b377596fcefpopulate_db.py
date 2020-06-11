# -*- encoding: utf-8 -*-

from ahtung_api.models import Person, Group, Signal, EnabledSignal

def populate():
    s1 = Signal(name="Alarm", signal_id="1")
    s2 = Signal(name="Warning", signal_id="2")
    s3 = Signal(name="Cancel", signal_id="3")
    
    s1.save()
    s2.save()
    s3.save()

    g1 = Group(group_id='123123')
    g2 = Group(group_id='123124')

    g1.save()
    g2.save()

    en1 = EnabledSignal(group=g1, signal=s1)
    en2 = EnabledSignal(group=g1, signal=s2)
    en3 = EnabledSignal(group=g1, signal=s3)

    en4 = EnabledSignal(group=g2, signal=s1)
    en5 = EnabledSignal(group=g2, signal=s3)

    en1.save()
    en2.save()
    en3.save()
    en4.save()
    en5.save()

    u1 = Person(name=u"Вася Пупкин", group=g1, registration_id='12353')
    u2 = Person(name=u"Иван Помидоров", group=g1, registration_id='45678')
    u3 = Person(name=u"Коля Иванов", group=g1, registration_id='457932')
    u4 = Person(name=u"Женя Некрасов", group=g2, registration_id='122345')
    u5 = Person(name=u"Галя Петрова", group=g2, registration_id='578632')

    u1.save()
    u2.save()
    u3.save()
    u4.save()
    u5.save()


