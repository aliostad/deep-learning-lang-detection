package br.com.fean.sgm.service;

import br.com.fean.sgm.service.impl.LocalPublicacaoService;
import br.com.fean.sgm.service.impl.PapelService;
import br.com.fean.sgm.service.impl.PessoaService;
import br.com.fean.sgm.service.impl.PlanoTrabalhoService;
import br.com.fean.sgm.service.impl.ProducaoPessoaService;
import br.com.fean.sgm.service.impl.ProducaoService;
import br.com.fean.sgm.service.impl.QualisService;
import br.com.fean.sgm.service.impl.SituacaoProducaoService;
import br.com.fean.sgm.service.impl.TipoPessoaService;
import br.com.fean.sgm.service.impl.TipoProducaoService;
import br.com.fean.sgm.service.impl.TurmaService;
import br.com.fean.sgm.service.impl.UtilService;


public class ServiceFactory {

    private static final ILocalPublicacaoService localPublicacaoService = new LocalPublicacaoService();
    private static final IPapelService papelService = new PapelService();
    private static final IPessoaService pessoaService = new PessoaService();
    private static final IPlanoTrabalhoService planoTrabalhoService = new PlanoTrabalhoService();
    private static final IProducaoService producaoService = new ProducaoService();
    private static final IProducaoPessoaService producaoPessoaService = new ProducaoPessoaService();
    private static final IQualisService qualisService = new QualisService();
    private static final ISituacaoProducaoService situacaoProducaoService = new SituacaoProducaoService();
    private static final ITipoPessoaService tipoPessoaService = new TipoPessoaService();
    private static final ITipoProducaoService tipoProducaoService = new TipoProducaoService();
    private static final ITurmaService turmaService = new TurmaService();
    private static final IUtilService  utilService = new UtilService();
    public static ILocalPublicacaoService getLocalPublicacaoService() {
        return localPublicacaoService;
    }

    public static IPapelService getPapelService() {
        return papelService;
    }

    public static IPessoaService getPessoaService() {
        return pessoaService;
    }

    public static IPlanoTrabalhoService getPlanoTrabalhoService() {
        return planoTrabalhoService;
    }

    public static IProducaoService getProducaoService() {
        return producaoService;
    }

    public static IProducaoPessoaService getProducaoPessoaService() {
        return producaoPessoaService;
    }

    public static IQualisService getQualisService() {
        return qualisService;
    }

    public static ISituacaoProducaoService getSituacaoProducaoService() {
        return situacaoProducaoService;
    }

    public static ITipoPessoaService getTipoPessoaService() {
        return tipoPessoaService;
    }

    public static ITipoProducaoService getTipoProducaoService() {
        return tipoProducaoService;
    }

    public static ITurmaService getTurmaService() {
        return turmaService;
    }
    public static IUtilService getUtilService() {
        return utilService;
    }
}
