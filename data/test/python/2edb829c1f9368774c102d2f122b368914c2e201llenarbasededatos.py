from mongomodels import Categoria, Producto, PrecioPasado

tecnologia = Categoria(nombre="Tecnologia").save()

tv = Categoria(nombre="TV", padre=tecnologia).save()
LCD = Categoria(nombre="Celulares", padre=tecnologia).save()
LED = Categoria(nombre="Camaras", padre=tecnologia).save()

computadoras = Categoria(nombre="computadoras", padre=tecnologia).save()
notebooks = Categoria(nombre="notebooks", padre=computadoras).save()
ultrabooks = Categoria(nombre="ultrabooks", padre=computadoras).save()
netbooks = Categoria(nombre="netbooks", padre=computadoras).save()

impresoras = Categoria(nombre="impresoras", padre=tecnologia).save()
multifuncionales = Categoria(
    nombre="multifuncionales", padre=impresoras).save()
laser = Categoria(nombre="laser", padre=impresoras).save()

Producto(
    sku="13130202",
    nombre='Recco LCD 32" HD RLCD-32B330',
    marca="Recco",
    precio="699",
    categoria=LCD,
    detalles={
        "Pantalla": "LCD",
        "Modelo": "RLCD-32B330",
        "Tam": '32"',
        "Resolucion": "1368 x 768"
    }
).save()

Producto(
    sku="13346659",
    nombre='Recco LCD 29" HD RLCD-29B330',
    marca="Recco",
    precio="599",
    categoria=LCD,
    detalles={
        "Pantalla": "LCD",
        "Modelo": "RLCD-29B330",
        "Tam": '29"',
        "Resolucion": "1368 x 768"
    }
).save()
