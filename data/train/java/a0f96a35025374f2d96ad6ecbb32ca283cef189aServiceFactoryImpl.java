/**
 * 
 */
package com.dookie.checktag.service.common;

import javax.ejb.EJB;
import javax.ejb.Stateless;

import com.dookie.checktag.persistence.common.DAOFactory;
import com.dookie.checktag.service.cliente.ClienteService;
import com.dookie.checktag.service.cliente.SegmentoService;
import com.dookie.checktag.service.conteudo.CapituloService;
import com.dookie.checktag.service.conteudo.ConteudoService;
import com.dookie.checktag.service.encomenda.EncomendaService;
import com.dookie.checktag.service.encomenda.FornecedorService;
import com.dookie.checktag.service.entrega.EntregaService;
import com.dookie.checktag.service.entrega.FreteService;
import com.dookie.checktag.service.idioma.IdiomaService;
import com.dookie.checktag.service.pacote.PacoteService;
import com.dookie.checktag.service.pagamento.PagamentoService;
import com.dookie.checktag.service.pedido.PedidoService;
import com.dookie.checktag.service.tags.TagService;
import com.dookie.checktag.service.tags.TagViewService;
import com.dookie.checktag.service.tags.TipoTagService;
import com.dookie.checktag.service.termo.TermoAdesaoService;
import com.dookie.checktag.service.venda.VendaService;
import com.dookie.utils.persistence.common.GenericDAOFactory;
import com.dookie.utils.service.common.GenericServiceFactoryImpl;

/**
 * @author eduardo
 * 
 */
@Stateless
public class ServiceFactoryImpl extends GenericServiceFactoryImpl implements ServiceFactory {

	/**
	 * long - serialVersionUID
	 */
	private static final long serialVersionUID = 977962662621212292L;

	/**
	 * Dao Factory.
	 */
	@EJB
	protected DAOFactory daoFactory;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dk.utils.service.common.GenericServiceFactory#getDAOFactory()
	 */
	@Override
	public GenericDAOFactory getDAOFactory() {
		return daoFactory;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getService()
	 */
	@Override
	public TipoTagService getTipoTagService() {
		TipoTagService service = new TipoTagService();
		service.setDao(daoFactory.getTipoTagDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getIdiomaService()
	 */
	@Override
	public IdiomaService getIdiomaService() {
		IdiomaService service = new IdiomaService();
		service.setDao(daoFactory.getIdiomaDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getPacoteService()
	 */
	@Override
	public PacoteService getPacoteService() {
		PacoteService service = new PacoteService();
		service.setDao(daoFactory.getPacoteDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getTagService()
	 */
	@Override
	public TagService getTagService() {
		TagService service = new TagService();
		service.setDao(daoFactory.getTagDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.dookie.checktag.service.common.ServiceFactory#getTermoAdesaoService()
	 */
	@Override
	public TermoAdesaoService getTermoAdesaoService() {
		TermoAdesaoService service = new TermoAdesaoService();
		service.setDao(daoFactory.getTermoAdesaoDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.dookie.checktag.service.common.ServiceFactory#getTipContentService()
	 */
	@Override
	public CapituloService getCapituloService() {
		CapituloService service = new CapituloService();
		service.setDao(daoFactory.getCapituloDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getTipService()
	 */
	@Override
	public ConteudoService getConteudoService() {
		ConteudoService service = new ConteudoService();
		service.setDao(daoFactory.getConteudoDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getClienteService()
	 */
	@Override
	public ClienteService getClienteService() {
		ClienteService service = new ClienteService();
		service.setDao(daoFactory.getClienteDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getTagViewService()
	 */
	@Override
	public TagViewService getTagViewService() {
		TagViewService service = new TagViewService();
		service.setDao(daoFactory.getTagViewDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getPedidoService()
	 */
	@Override
	public PedidoService getPedidoService() {
		PedidoService service = new PedidoService();
		service.setDao(daoFactory.getPedidoDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.dookie.checktag.service.common.ServiceFactory#getPagamentoService()
	 */
	@Override
	public PagamentoService getPagamentoService() {
		PagamentoService service = new PagamentoService();
		service.setDao(daoFactory.getPagamentoDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.dookie.checktag.service.common.ServiceFactory#getFornecedorService()
	 */
	@Override
	public FornecedorService getFornecedorService() {
		FornecedorService service = new FornecedorService();
		service.setDao(daoFactory.getFornecedorDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.dookie.checktag.service.common.ServiceFactory#getEncomendaService()
	 */
	@Override
	public EncomendaService getEncomendaService() {
		EncomendaService service = new EncomendaService();
		service.setDao(daoFactory.getEncomendaDAO());
		service.setServiceFactory(this);
		return service;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getEntregaService()
	 */
	@Override
	public EntregaService getEntregaService() {
		EntregaService service = new EntregaService();
		service.setDao(daoFactory.getEntregaDAO());
		service.setServiceFactory(this);
		return service;
	}
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getVendaService()
	 */
	@Override
	public VendaService getVendaService() {
		VendaService service = new VendaService();
		service.setDao(daoFactory.getVendaDAO());
		service.setServiceFactory(this);
		return service;
	}
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getArquivoService()
	 */
	@Override
	public ArquivoService getArquivoService() {
		ArquivoService service = new ArquivoService();
		service.setDao(daoFactory.getArquivoDAO());
		service.setServiceFactory(this);
		return service;
	}
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see com.dookie.checktag.service.common.ServiceFactory#getFreteService()
	 */
	@Override
	public FreteService getFreteService() {
		FreteService service = new FreteService();
//		service.setDao(daoFactory.getVendaDAO());
		service.setServiceFactory(this);
		return service;
	}

	@Override
	public SegmentoService getSegmentoService() {
		SegmentoService service = new SegmentoService();
		service.setDao(daoFactory.getSegmentoDAO());
		service.setServiceFactory(this);
		return service;
	}

}
