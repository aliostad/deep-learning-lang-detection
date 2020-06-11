/**
 * 
 */
package com.dookie.checktag.service.common;

import javax.ejb.Local;

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
import com.dookie.utils.service.common.GenericServiceFactory;

/**
 * Fábrica de serviços de negocio.
 * 
 * @author eduardo
 * 
 */
@Local
public interface ServiceFactory extends GenericServiceFactory {

	/**
	 * Cria uma nova instancia de {@link ClienteService}.
	 * 
	 * @return
	 */
	ClienteService getClienteService();

	/**
	 * Cria uma nova instancia de {@link TipoTagService}.
	 * 
	 * @return
	 */
	TipoTagService getTipoTagService();

	/**
	 * Cria uma nova instancia de {@link IdiomaService}.
	 * 
	 * @return
	 */
	IdiomaService getIdiomaService();

	/**
	 * Cria uma nova instancia de {@link PacoteService}.
	 * 
	 * @return
	 */
	PacoteService getPacoteService();

	/**
	 * Cria uma nova instancia de {@link TagService}.
	 * 
	 * @return
	 */
	TagService getTagService();

	/**
	 * Cria uma nova instancia de {@link TermoAdesaoService}.
	 * 
	 * @return
	 */
	TermoAdesaoService getTermoAdesaoService();

	/**
	 * Cria uma nova instancia de {@link CapituloService}.
	 * 
	 * @return
	 */
	CapituloService getCapituloService();

	/**
	 * Cria uma nova instancia de {@link ConteudoService}.
	 * 
	 * @return
	 */
	ConteudoService getConteudoService();

	/**
	 * Cria uma nova instancia de {@link TagViewService}.
	 * 
	 * @return
	 */
	TagViewService getTagViewService();

	/**
	 * Cria uma nova instancia de {@link PedidoService}.
	 * 
	 * @return
	 */
	PedidoService getPedidoService();

	/**
	 * Cria uma nova instancia de {@link PagamentoService}.
	 * 
	 * @return
	 */
	PagamentoService getPagamentoService();

	/**
	 * Cria uma nova instancia de {@link FornecedorService}.
	 * 
	 * @return
	 */
	FornecedorService getFornecedorService();

	/**
	 * Cria uma nova instancia de {@link EncomendaService}.
	 * 
	 * @return
	 */
	EncomendaService getEncomendaService();

	/**
	 * Cria uma nova instancia de {@link EntregaService}.
	 * 
	 * @return
	 */
	EntregaService getEntregaService();
	
	/**
	 * Cria uma nova instancia de {@link VendaService}.
	 * 
	 * @return
	 */
	VendaService getVendaService();
	
	/**
	 * Cria uma nova instancia de {@link FreteService}.
	 * 
	 * @return
	 */
	FreteService getFreteService();
	
	/**
	 * Cria uma nova instancia de {@link ArquivoService}.
	 * 
	 * @return
	 */
	ArquivoService getArquivoService();
	
	/**
	 * Cria uma nova instancia de {@link SegmentoService}.
	 * 
	 * @return
	 */
	SegmentoService getSegmentoService();

}
