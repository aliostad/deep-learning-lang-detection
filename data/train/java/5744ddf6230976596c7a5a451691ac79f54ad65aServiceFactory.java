package br.com.xkinfo.slc.Service;

import br.com.xkinfo.slc.Service.Impl.AbastecimentoServiceImpl;
import br.com.xkinfo.slc.Service.Impl.CompetenciaServiceImpl;

public class ServiceFactory {

    private static IAbastecimentoService abastecimentoService;

    public static IAbastecimentoService getAbastecimentoService() {
        if (abastecimentoService == null) {
            abastecimentoService = new AbastecimentoServiceImpl();
        }
        return abastecimentoService;
    }
    private static ICompetenciaService competenciaService;

    public static ICompetenciaService getCompetenciaService() {
        if (competenciaService == null) {
            competenciaService = new CompetenciaServiceImpl();
        }
        return competenciaService;
    }
}
