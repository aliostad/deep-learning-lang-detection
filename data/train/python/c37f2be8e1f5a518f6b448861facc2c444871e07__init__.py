# encoding=UTF-8
"""Modulo principal que inicializa el Gestor Académico
"""
__author__ = 'Gregorio y Ángel'
from src.Terminal import *
from src.Controladores.AlumnoController import *
from src.Controladores.AsignaturaController import *
from src.Controladores.CentroController import *
from src.Controladores.GradoController import *
from src.Controladores.SesionController import *


def main():
    """
    1 - Crea un contenedor de las vistas y añade las intancias de éstas.\n
    2 - Inicializa los controladores de las entidades del proyecto.\n
    3 - Asigna los controladores anteriormente inicializados a cada vista del contenedor, y posteriormente la lanza
    """
    terminales = list()
    terminales.append(Terminal())

    alumno_controller = AlumnoController(terminales)
    asignatura_controller = AsignaturaController(terminales)
    centro_controller = CentroController(terminales)
    grado_controller = GradoController(terminales)
    sesion_controller = SesionController(terminales)

    for terminal in terminales:
        terminal.set_alumno_controller(alumno_controller)
        terminal.set_asignatura_controller(asignatura_controller)
        terminal.set_centro_controller(centro_controller)
        terminal.set_grado_controller(grado_controller)
        terminal.set_sesion_controller(sesion_controller)
        terminal.iniciar()


if __name__ == "__main__":
    main()