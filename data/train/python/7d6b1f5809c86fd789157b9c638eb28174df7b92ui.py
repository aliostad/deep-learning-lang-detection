__author__ = 'jedi'

from controller.cocheController import *
from controller.dbController import *
from model.coche import *

import sys
sys.path.insert(0, '../model')

while(True):
    print("Bienvenido a la Tienda!")
    print("1. Alquila un coche disponible")
    print("2. Lista Coches disponibles: ")
    print("3. Lista Coches alquilados en este momento: ")
    print("4. Añade un nuevo coche: ")
    print("5. Conoce los ingresos totales entre 2 fechas: ")

    opcion = int(input("Selecciona una opcion: "))

    cocheController = CocheController()
    dbController = DbController()

    if(opcion == 1):
        cocheController.newAlquileresCoches()

    if(opcion == 2):
        dbController.getAllCochesDisponibles()

    if(opcion == 3):
        dbController.getAllCochesAlquilados()

    if(opcion == 4):
        cocheController.newCoche()

    if(opcion == 5):
        cocheController.ingresosTotales()

