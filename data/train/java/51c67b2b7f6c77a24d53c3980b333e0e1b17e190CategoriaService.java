package br.com.ifrn.workbook.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import br.com.ifrn.workbook.model.servico.Categoria;
import br.com.ifrn.workbook.repository.CategoriaRepository;

@Service
public class CategoriaService extends BaseService<Categoria, Long>{
	
	private final CategoriaRepository categoriaRepository;

	@Inject
	public CategoriaService(CategoriaRepository categoriaRepository) {
		super(categoriaRepository);
		this.categoriaRepository = categoriaRepository;
	}
	
	

}
