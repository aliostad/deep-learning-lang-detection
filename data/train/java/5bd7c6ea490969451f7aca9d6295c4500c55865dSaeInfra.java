package br.unb.sae.infra;

import javax.ejb.EJB;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Singleton
@Startup
public class SaeInfra {
	private static SaeInfra instance;
	public static SaeInfra getInstance(){ return instance; }
 
	@EJB private ValorAlimentacaoRepository valorAlimentacaoRepository;
	@EJB private AssinaturaTermoBaRepository assinaturaTermoBaRepository;
	@EJB private OcorrenciaRepository ocorrenciaRepository;
	@EJB private AgendaRepository agendaRepository;
	@EJB private AgendamentoRepository agendamentoRepository;
	@EJB private EstudoPreliminarRepository estudoPreliminarRepository;
	@EJB private DocumentacaoPendenteRepository documentacaoPendenteRepository;
	@EJB private DocumentacaoRepository documentacaoRepository;
	@EJB private EstudoSocioEconomicoRepository estudoSocioEconomicoRepository;


	public SaeInfra(){
		instance = this;
	}
	
	

	@PersistenceContext(unitName = "service_context")
	public EntityManager saeContext;

	public ValorAlimentacaoRepository getValorAlimentacaoRepository() {
		return valorAlimentacaoRepository;
	}

	public AssinaturaTermoBaRepository getAssinaturaTermoBaRepository() {
		return assinaturaTermoBaRepository;
	}

	public OcorrenciaRepository getOcorrenciaRepository() {
		return ocorrenciaRepository;
	}

	public void setOcorrenciaRepository(OcorrenciaRepository ocorrenciaRepository) {
		this.ocorrenciaRepository = ocorrenciaRepository;
	}

	public AgendaRepository getAgendaRepository() {
		return agendaRepository;
	}

	public AgendamentoRepository getAgendamentoRepository() {
		return agendamentoRepository;
	}

	public EntityManager getSaeContext() {
		return saeContext;
	}

	public EstudoPreliminarRepository getEstudoPreliminarRepository() {
		return estudoPreliminarRepository;
	}
	
	public DocumentacaoPendenteRepository getDocumentacaoPendenteRepository() {
		return documentacaoPendenteRepository;
	}
	
	public DocumentacaoRepository getDocumentacaoRepository() {
		return documentacaoRepository;
	}

	public EstudoSocioEconomicoRepository getEstudoSocioEconomicoRepository() {
		return estudoSocioEconomicoRepository;
	}
	
	
}
