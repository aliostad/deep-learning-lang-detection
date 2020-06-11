# -*- encoding: utf-8 -*-
from actividades.models import Tipo_Actividad, Nivel_Actividad

na = Nivel_Actividad(nombre='Baby')
na.save()
na = Nivel_Actividad(nombre='Iniciación')
na.save()
na = Nivel_Actividad(nombre='Pre-Infantil')
na.save()
na = Nivel_Actividad(nombre='Infantil')
na.save()
na = Nivel_Actividad(nombre='Infantil-Juvenil')
na.save()
na = Nivel_Actividad(nombre='Juvenil')
na.save()
na = Nivel_Actividad(nombre='Adulto')
na.save()

print "Nivel Actividad"

####################################################################################################

ta = Tipo_Actividad(nombre='Coro')
ta.save()
ta = Tipo_Actividad(nombre='Orquesta')
ta.save()

print "Tipo Actividad"

####################################################################################################


from alumnos.models import Nivel_I

ni = Nivel_I(nombre='Preparatorio')
ni.save()
ni = Nivel_I(nombre='Iniciación')
ni.save()
ni = Nivel_I(nombre='I')
ni.save()
ni = Nivel_I(nombre='II')
ni.save()
ni = Nivel_I(nombre='III')
ni.save()
ni = Nivel_I(nombre='IV')
ni.save()
ni = Nivel_I(nombre='V')
ni.save()

print "Nivel Instrumento"

####################################################################################################

from clases.models import Catedra, Nivel, Seccion

ca = Catedra(nombre='Flauta Dulce')
ca.save()
ca = Catedra(nombre='Lenguaje Musical')
ca.save()
ca = Catedra(nombre='Historia de la Música')
ca.save()
ca = Catedra(nombre='Cuatro')
ca.save()
ca = Catedra(nombre='Guitarra')
ca.save()

print "Cátedra"

####################################################################################################

ni = Nivel(nombre='Preparatorio I')
ni.save()
ni = Nivel(nombre='Preparatorio II')
ni.save()
ni = Nivel(nombre='1° Año')
ni.save()
ni = Nivel(nombre='2° Año')
ni.save()
ni = Nivel(nombre='3° Año')
ni.save()
ni = Nivel(nombre='4° Año')
ni.save()
ni = Nivel(nombre='5° Año')
ni.save()

print "Nivel Clase"

####################################################################################################

se = Seccion(nombre='A')
se.save()
se = Seccion(nombre='B')
se.save()
se = Seccion(nombre='C')
se.save()
se = Seccion(nombre='D')
se.save()

print "Sección"

####################################################################################################

from horarios.models import Dia

di = Dia(nombre='Domingo')
di.save()
di = Dia(nombre='Lunes')
di.save()
di = Dia(nombre='Martes')
di.save()
di = Dia(nombre='Miércoles')
di.save()
di = Dia(nombre='Jueves')
di.save()
di = Dia(nombre='Viernes')
di.save()
di = Dia(nombre='Sábado')
di.save()

print "Día"

####################################################################################################

from instrumentos.models import Tipo_Instrumento, Instrumento

ti = Tipo_Instrumento(nombre='Clasico')
ti.save()
ti = Tipo_Instrumento(nombre='Folklorico')
ti.save()
ti = Tipo_Instrumento(nombre='Voz')
ti.save()

print "Tipo Instrumento"

####################################################################################################

i = Instrumento(nombre='Violín', instrumento_id=int(1), orden=1)
i.save()
i = Instrumento(nombre='Viola', instrumento_id=int(1), orden=2)
i.save()
i = Instrumento(nombre='Violonchelo', instrumento_id=int(1), orden=3)
i.save()
i = Instrumento(nombre='Contrabajo', instrumento_id=int(1), orden=4)
i.save()
i = Instrumento(nombre='Oboe', instrumento_id=int(1), orden=5)
i.save()
i = Instrumento(nombre='Clarinete', instrumento_id=int(1), orden=6)
i.save()
i = Instrumento(nombre='Flauta Transversa', instrumento_id=int(1), orden=7)
i.save()
i = Instrumento(nombre='Fagot', instrumento_id=int(1), orden=8)
i.save()
i = Instrumento(nombre='Corno', instrumento_id=int(1), orden=9)
i.save()
i = Instrumento(nombre='Trompeta', instrumento_id=int(1), orden=10)
i.save()
i = Instrumento(nombre='Trombon', instrumento_id=int(1), orden=11)
i.save()
i = Instrumento(nombre='Tuba', instrumento_id=int(1), orden=12)
i.save()
i = Instrumento(nombre='Percusión', instrumento_id=int(1), orden=13)
i.save()
i = Instrumento(nombre='Primera Voz', instrumento_id=int(3), orden=14)
i.save()
i = Instrumento(nombre='Segunda Voz', instrumento_id=int(3), orden=15)
i.save()
i = Instrumento(nombre='Soprano', instrumento_id=int(3), orden=16)
i.save()
i = Instrumento(nombre='Contralto', instrumento_id=int(3), orden=17)
i.save()
i = Instrumento(nombre='Tenor', instrumento_id=int(3), orden=18)
i.save()
i = Instrumento(nombre='Bajo', instrumento_id=int(3), orden=19)
i.save()

print "Instrumento"

####################################################################################################

from profesores.models import Cargo

ca = Cargo(nombre='Asistente')
ca.save()
ca = Cargo(nombre='Director')
ca.save()

print "Cargo"
####################################################################################################

print "Carga completa..."