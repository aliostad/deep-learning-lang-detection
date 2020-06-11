#include "loadAnimacion.h"


LoadAnimacion::LoadAnimacion()
{
	nombre = ERROR;
	offset = ERROR;
	cantidad = ERROR;
	periodo = ERROR;
}

void LoadAnimacion::setOffset(string param){
	offset = param;
}

void LoadAnimacion::setCantidad(string param){
	cantidad = param;
}

void LoadAnimacion::setNombre(string param){
	nombre = param;
}

void LoadAnimacion::setPeriodo(string param){
		periodo = param;
}

string LoadAnimacion::getOffset(){
	return offset;
}

string LoadAnimacion::getCantidad(){
	return cantidad;
}

string LoadAnimacion::getNombre(){
	return nombre;
}

string LoadAnimacion::getPeriodo(){
	return periodo;
}

LoadAnimacion::~LoadAnimacion()
{

}

