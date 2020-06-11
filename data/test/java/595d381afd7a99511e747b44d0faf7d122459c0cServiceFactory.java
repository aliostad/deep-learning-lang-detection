package br.com.fean.poo2.projeto.service;

import br.com.fean.poo2.projeto.service.impl.DepartamentoService;
import br.com.fean.poo2.projeto.service.impl.EmpregadoService;
import br.com.fean.poo2.projeto.service.impl.ProjetoService;
import br.com.fean.poo2.projeto.service.impl.UtilService;

public class ServiceFactory {

    private static final IUtilService utilService = new UtilService();

    public static IUtilService getUtilService() {
        return utilService;
    }
    private static final IProjetoService projetoService = new ProjetoService();

    public static IProjetoService getProjetoService() {
        return projetoService;
    }
    private static final IDepartamentoService departamentoService = new DepartamentoService();

    public static IDepartamentoService getDepartamentoService() {
        return departamentoService;
    }
    private static final IEmpregadoService empregadoService = new EmpregadoService();

    public static IEmpregadoService getEmpregadoService() {
        return empregadoService;
    }
}
