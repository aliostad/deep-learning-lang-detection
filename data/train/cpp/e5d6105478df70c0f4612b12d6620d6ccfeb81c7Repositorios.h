#pragma once
#include "KeyRepository.h"
#include "../models/compras/Articulo.h"
#include "../models/compras/LineaEspecifica.h"
#include "../models/compras/LineaGeneral.h"
#include "../models/compras/Categoria.h"
#include "../models/usuarios/Usuario.h"
#include "../models/compras/Carrito.h"
#include "MultiRepo.h"
#include "Session.h"
//Problema al incluir #include "../models/compras/LineaEspecifica.h"

class Repositorios
{
public:
	static KeyRepository<Articulo> repoArticulo;
	static KeyRepository<LineaEspecifica> repoLineaEspecifica;
	static KeyRepository<LineaGeneral> repoLineaGeneral;
	static KeyRepository<Categoria> repoCategoria;
	static KeyRepository<Usuario> repoUsuario;
	static MultiRepo<Carrito> repoCompras;
    static MultiRepo<Carrito> repoCarritos;
	static Session session;


};

