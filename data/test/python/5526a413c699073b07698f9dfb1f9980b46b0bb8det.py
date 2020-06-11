

from tracker.models import Contatto, DettaglioContatto as DC

for c in Contatto.objects.all():
    if c.telefono:
        #d = DC(contatto=c, tipo=1, valore=c.telefono)
        #d.save()
        c.telefono = ''
    if c.fax:
        d = DC(contatto=c, tipo=10, valore=c.fax)
        d.save()
        c.fax = ''
    if c.email:
        d = DC(contatto=c, tipo=20, valore=c.email)
        d.save()
        c.email = ''
    if c.sito:
        d = DC(contatto=c, tipo=30, valore=c.sito)
        d.save()
        c.sito = ''
    c.save()


