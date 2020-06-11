#include "ByteStream.h"
#include <cstring>

ByteStream::ByteStream(size_t capacidad) :
		stream(NULL), capacidad(capacidad), tamanio(0) {
	if (capacidad > 0) {
		stream = new byte_t[capacidad];
	}
}

ByteStream::ByteStream(const byte_t* stream, size_t tamanio) :
		stream(NULL), capacidad(tamanio), tamanio(tamanio) {
	if (tamanio > 0) {
		this->stream = new byte_t[tamanio];
		memcpy(this->stream, stream, tamanio);
	}
}

ByteStream::ByteStream(const ByteStream& aCopiar) :
		stream(NULL) {
	copiar(aCopiar);
}

void ByteStream::asignarStream(const byte_t* stream, size_t tamanio) {
	if (tamanio > capacidad) {
		if (this->stream != NULL) {
			delete[] this->stream;
		}
		this->stream = new byte_t[tamanio];
		capacidad = tamanio;
	}
	this->tamanio = tamanio;
	if (tamanio > 0) {
		memcpy(this->stream, stream, tamanio);
	}
}

void ByteStream::redimensionar(size_t nuevaCapacidad) {
	capacidad = nuevaCapacidad;
	if (capacidad <= 0) {
		tamanio = 0;
		if (stream != NULL) {
			delete[] stream;
		}
		stream = NULL;
	}
	else {
		byte_t *nuevo = new byte_t[capacidad];

		/* Si la nueva capacidad es menor al tamanio ocupado actual, al
		 * achicarse el stream se pierden datos y este queda lleno */
		if (tamanio > capacidad) {
			tamanio = capacidad;
		}

		memcpy(nuevo, stream, tamanio);
		delete[] stream;
		stream = nuevo;
	}
}

void ByteStream::insertarDatos(const void* dato, size_t tamanioDato) {
	if ((tamanio + tamanioDato) > capacidad) {
		redimensionar(tamanio + tamanioDato);
	}
	memcpy(&stream[tamanio], dato, tamanioDato);
	tamanio += tamanioDato;
}

void ByteStream::vaciarStream() {
	tamanio = 0;
}

const byte_t* ByteStream::obtenerStream() const {
	return stream;
}

size_t ByteStream::getTamanioOcupado() const {
	return tamanio;
}

size_t ByteStream::getCapacidadTotal() const {
	return capacidad;
}

size_t ByteStream::getCapacidadRestante() const {
	return (capacidad - tamanio);
}

bool ByteStream::estaLleno() const {
	return (capacidad == tamanio);
}

ByteStream& ByteStream::operator=(const ByteStream& aCopiar) {
	copiar(aCopiar);
	return *this;
}

ByteStream::~ByteStream() {
	if (stream != NULL) {
		delete[] stream;
	}
}

void ByteStream::copiar(const ByteStream& aCopiar) {
	if (stream != NULL) {
		delete[] stream;
		stream = NULL;
	}
	capacidad = aCopiar.capacidad;
	tamanio = aCopiar.tamanio;
	if (aCopiar.stream != NULL) {
		stream = new byte_t[capacidad];
		memcpy(stream, aCopiar.stream, tamanio);
	}
}
