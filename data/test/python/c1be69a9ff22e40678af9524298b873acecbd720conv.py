from tracker.models import *

for c in Contatto.objects.all():
  if len( c.nota_set.all() ) > 1:
    print 'maggiore ', c
    continue

  try:
    nota = c.nota_set.all()[0]

    print nota.testo.encode('latin-1')
    if nota.testo == 'Fascia 1':
      c.priorita = 1
      c.save()
      nota.testo = ''
      nota.save()
    if nota.testo == 'Fascia 2':
      c.priorita = 2
      c.save()
      nota.testo = ''
      nota.save()
    if nota.testo == 'Fascia 3':
      c.priorita = 3
      c.save()
      nota.testo = ''
      nota.save()

  except Nota.DoesNotExist: pass
