#include "loadElementoMapa.h"


LoadElementoMapa::LoadElementoMapa() {
	textura = ERROR;
	x = ERROR;
	y = ERROR;
}

void LoadElementoMapa::setX(string param){
	x = param;
}
void LoadElementoMapa::setY(string param){
	y = param;
}

void LoadElementoMapa::setTextura(string param){
	textura = param;
}

void LoadElementoMapa::setAlto(string param){
	alto = param;
}

void LoadElementoMapa::setAncho(string param){
	ancho = param;
}

void LoadElementoMapa::setRozamiento(string param){
	rozamiento = param;
}

void LoadElementoMapa::setAngulo(string param){
	angulo = param;
}
						
string LoadElementoMapa::getX(){
	return x;
}


string LoadElementoMapa::getRozamiento(){
	return rozamiento;
}


string LoadElementoMapa::getY(){
	return y;
}

string LoadElementoMapa::getTextura(){
	return textura;
}

string LoadElementoMapa::getAlto(){
	return alto;
}

string LoadElementoMapa::getAncho(){
	return ancho;
}

string LoadElementoMapa::getAngulo(){
	return angulo;
}

LoadElementoMapa::~LoadElementoMapa()
{
	
}

