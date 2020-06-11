package br.com.fean.poo2.provaav1.service;

import br.com.fean.poo2.provaav1.service.impl.ColaboradorService;
import br.com.fean.poo2.provaav1.service.impl.EmpregadoService;
import br.com.fean.poo2.provaav1.service.impl.FuncionarioService;



public class ServiceFactory {

    private static final IFuncionarioService funcionarioService = new FuncionarioService();

    public static IFuncionarioService getFuncionarioService() {
        return funcionarioService;
    }
    private static final IColaboradorService colaboradorService = new ColaboradorService();

    public static IColaboradorService getColaboradorService() {
        return colaboradorService;
    }
    private static final IEmpregadoService empregadoService = new EmpregadoService();

    public static IEmpregadoService getEmpregadoService() {
        return empregadoService;
    }
}
