# -*- coding: utf-8 -*-

from landing.models import *
from django.db import connection

def process():

	cursor = connection.cursor()

	cursor.execute("DELETE FROM landing_question")
	cursor.execute("DELETE FROM landing_answer")

	cursor.close()

	q = Question(code=1, question="¿Utiliza medios digitales para consultar la información de viajes?", qtype=0)

	a1 = Answer(question=q, body="Si",code=1)
	a2 = Answer(question=q, body="No",code=2)

	q.save()
	a1.save()
	a2.save()

	q = Question(code=2, question="¿Le parece apropiada la estandarización de precios en el trasporte?", qtype=0)

	a1 = Answer(question=q, body="Si", code=1)
	a2 = Answer(question=q, body="No", code=2)

	q.save()
	a1.save()
	a2.save()

	q = Question(code=3, question="¿Qué tipo de servicio de transporte presta?", qtype=1)

	a1 = Answer(question=q, body="Transporte terrestre de carga", code=1)
	a2 = Answer(question=q, body="Transporte de valores", code=2)
	a3 = Answer(question=q, body="Transporte urbano de mercancías", code=3)
	a4 = Answer(question=q, body="Otro", code=4)

	q.save()
	a1.save()
	a2.save()
	a3.save()
	a4.save()

	q = Question(code=4, question="¿Cómo consigue sus clientes?", qtype=1)

	a1 = Answer(question=q, body="Publicidad", code=1)
	a2 = Answer(question=q, body="Página web", code=2)
	a3 = Answer(question=q, body="Vendedores", code=3)
	a4 = Answer(question=q, body="Otro", code=4)

	q.save()
	a1.save()
	a2.save()
	a3.save()
	a4.save()

	q = Question(code=5, question="¿Tiene suficientes clientes?", qtype=0)

	a1 = Answer(question=q, body="Si", code=1)
	a2 = Answer(question=q, body="No", code=2)

	q.save()
	a1.save()
	a2.save()

	q = Question(code=6, question="¿Cómo fija el precio de un servicio de transporte?", qtype=0)

	a1 = Answer(question=q, body="Negociación con el cliente", code=1)
	a2 = Answer(question=q, body="Tabla de precios según peso", code=2)
	a3 = Answer(question=q, body="Tabla de precios según ocupación", code=3)

	q.save()
	a1.save()
	a2.save()
	a3.save()

	q = Question(code=7, question="¿Le llama la atención utilizar una plataforma virtual para promocionar sus servicios?", qtype=0)

	a1 = Answer(question=q, body="Si", code=1)
	a2 = Answer(question=q, body="No", code=2)

	q.save()
	a1.save()
	a2.save()

	q = Question(code=8, question="¿Le gustaría recibir sus pagos a través de una herramienta virtual?", qtype=0)

	a1 = Answer(question=q, body="Si", code=1)
	a2 = Answer(question=q, body="No", code=2)
	a3 = Answer(question=q, body="No me da seguridad", code=3)

	q.save()
	a1.save()
	a2.save()
	a3.save()

	q = Question(code=9, question="¿Estaría dispuesto a pagar una comisión entre el 1% y 5% por el servicio de promoción que ofrece Cargalo", qtype=0)

	a1 = Answer(question=q, body="Si", code=1)
	a2 = Answer(question=q, body="No", code=2)
	a3 = Answer(question=q, body="La comisión es muy alta", code=3)

	q.save()
	a1.save()
	a2.save()
	a3.save()