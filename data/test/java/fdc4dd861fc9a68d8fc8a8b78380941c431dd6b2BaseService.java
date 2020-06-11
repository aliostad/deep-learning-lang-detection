package org.apm.carteiraprofissional.service.util;

import org.apm.carteiraprofissional.service.CategoriaService;
import org.apm.carteiraprofissional.service.EscolaridadeService;
import org.apm.carteiraprofissional.service.RequisitanteService;
import org.apm.carteiraprofissional.service.TipoDocumentoService;
import org.springframework.beans.factory.annotation.Autowired;

public abstract class BaseService {

	
	protected RequisitanteService requisicaoService;

	@Autowired
	protected EscolaridadeService escolaridadeService;

	@Autowired
	protected TipoDocumentoService tipoDocumentoService;

	@Autowired
	protected CategoriaService categoriaService;
}
