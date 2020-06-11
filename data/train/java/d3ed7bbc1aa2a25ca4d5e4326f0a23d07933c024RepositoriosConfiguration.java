package br.com.pat.mvc.conf;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import br.com.pat.mvc.repositories.CompraRepository;
import br.com.pat.mvc.repositories.CompraRepositoryHibernate;
import br.com.pat.mvc.repositories.MercadoRepository;
import br.com.pat.mvc.repositories.MercadoRepositoryHibernate;
import br.com.pat.mvc.repositories.ProdutoRepository;
import br.com.pat.mvc.repositories.ProdutoRepositoyHibernate;
import br.com.pat.mvc.repositories.UsuarioRepository;
import br.com.pat.mvc.repositories.UsuarioRepositoryHibernate;

@Configuration
public class RepositoriosConfiguration {

	@Bean(name = "usuarioRepository")
	public UsuarioRepository getUsuarioRepository() {
		return new UsuarioRepositoryHibernate();
	}

	@Bean(name = "compraRepository")
	public CompraRepository getCompraRepository() {
		return new CompraRepositoryHibernate();
	}

	@Bean(name = "produtoRepository")
	public ProdutoRepository getProdutoRepository() {
		return new ProdutoRepositoyHibernate();
	}

	@Bean(name = "mercadoRepository")
	public MercadoRepository getMercadoRepository() {
		return new MercadoRepositoryHibernate();
	}

}
