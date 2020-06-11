package br.com.level.celesc.service;

import br.com.level.celesc.service.impl.ConcessionariaService;
import br.com.level.celesc.service.impl.EmpreiteiraService;
import br.com.level.celesc.service.impl.EmpresaUsuarioService;
import br.com.level.celesc.service.impl.EntregaService;
import br.com.level.celesc.service.impl.ErroService;
import br.com.level.celesc.service.impl.ImportacaoService;
import br.com.level.celesc.service.impl.LeituristaService;
import br.com.level.celesc.service.impl.LocalidadeService;
import br.com.level.celesc.service.impl.OcorrenciaService;
import br.com.level.celesc.service.impl.ReclamacaoService;
import br.com.level.celesc.service.impl.ReferenciaLivroService;
import br.com.level.celesc.service.impl.RetornoService;
import br.com.level.celesc.service.impl.ServicoService;
import br.com.level.celesc.service.impl.SituacaoService;
import br.com.level.celesc.service.impl.TipoLocalidadeService;
import br.com.level.celesc.service.impl.UsuarioService;
import br.com.level.celesc.service.impl.UtilService;

public class ServiceFactory {

    private static final IUtilService utilService = new UtilService();

    public static IUtilService getUtilService() {
        return utilService;
    }
    private static final IConcessionariaService concessionariaService = new ConcessionariaService();

    public static IConcessionariaService getConcessionariaService() {
        return concessionariaService;
    }
    private static final IEmpreiteiraService empreiteiraService = new EmpreiteiraService();

    public static IEmpreiteiraService getEmpreiteiraService() {
        return empreiteiraService;
    }
    private static final IEmpresaUsuarioService empresaUsuarioService = new EmpresaUsuarioService();

    public static IEmpresaUsuarioService getEmpresaUsuarioService() {
        return empresaUsuarioService;
    }
    private static final IEntregaService entregaService = new EntregaService();

    public static IEntregaService getEntregaService() {
        return entregaService;
    }
    private static final IErroService erroService = new ErroService();

    public static IErroService getErroService() {
        return erroService;
    }
    private static final IImportacaoService importacaoService = new ImportacaoService();

    public static IImportacaoService getImportacaoService() {
        return importacaoService;
    }
    private static final ILeituristaService leituristaService = new LeituristaService();

    public static ILeituristaService getLeituristaService() {
        return leituristaService;
    }
    private static final ILocalidadeService localidadeService = new LocalidadeService();

    public static ILocalidadeService getLocalidadeService() {
        return localidadeService;
    }
    private static final IOcorrenciaService ocorrenciaService = new OcorrenciaService();

    public static IOcorrenciaService getOcorrenciaService() {
        return ocorrenciaService;
    }
    private static final IReclamacaoService reclamacaoService = new ReclamacaoService();

    public static IReclamacaoService getReclamacaoService() {
        return reclamacaoService;
    }
    private static final IReferenciaLivroService referenciaLivroService = new ReferenciaLivroService();

    public static IReferenciaLivroService getReferenciaLivroService() {
        return referenciaLivroService;
    }
    private static final IRetornoService retornoService = new RetornoService();

    public static IRetornoService getRetornoService() {
        return retornoService;
    }
    private static final IServicoService servicoService = new ServicoService();

    public static IServicoService getServicoService() {
        return servicoService;
    }
    private static final ISituacaoService situacaoService = new SituacaoService();

    public static ISituacaoService getSituacaoService() {
        return situacaoService;
    }
    private static final ITipoLocalidadeService tipoLocalidadeService = new TipoLocalidadeService();

    public static ITipoLocalidadeService getTipoLocalidadeService() {
        return tipoLocalidadeService;
    }
    private static final IUsuarioService usuarioService = new UsuarioService();

    public static IUsuarioService getUsuarioService() {
        return usuarioService;
    }
}
