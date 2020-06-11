package com.gduranti.processengine;

import static org.junit.Assert.assertEquals;

import javax.inject.Inject;

import org.jboss.arquillian.junit.Arquillian;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import com.gduranti.processengine.model.Process;
import com.gduranti.processengine.model.ProcessInstance;
import com.gduranti.processengine.model.ProcessStatus;
import com.gduranti.processengine.model.ProcessStep;
import com.gduranti.processengine.model.ProcessType;
import com.gduranti.processengine.model.ProcessTypeVersion;
import com.gduranti.processengine.model.ServiceType;

@RunWith(Arquillian.class)
public class ProcessFacadeIT extends AbstractIntegratedTest {

    private static final Object UM_ED_QUALQUER = new Object();

    @Inject
    private ProcessFacade processFacade;

    private ProcessType processType;
    private ProcessStep aberturaProcessoStep;
    private ProcessStep vistoriaStep;
    private ProcessStep primeiroEmplacamentoStep;
    private ProcessStep conferenciaStep;
    private ProcessStep bcvaStep;
    private ProcessStep atualizacaoBinStep;
    private ProcessStep atualizacaoSngStep;
    private ProcessStep emissaoCrvCrlvStep;
    private ProcessStep encerramentoStep;

    @Before
    public void setUp() {
        buildTestProcessType();
    }

    private void buildTestProcessType() {
        processType = new ProcessType(101);
        ProcessTypeVersion processTypeVersion = processType.newVersion();

        aberturaProcessoStep = new ProcessStep(1, processTypeVersion, ServiceType.ABERTURA);
        vistoriaStep = new ProcessStep(2, processTypeVersion, ServiceType.VISTORIA);
        primeiroEmplacamentoStep = new ProcessStep(4, processTypeVersion, ServiceType.PRIMEIRO_EMPLACAMENTO);
        conferenciaStep = new ProcessStep(5, processTypeVersion, ServiceType.CONFERENCIA);
        bcvaStep = new ProcessStep(6, processTypeVersion, ServiceType.EMISSAO_BCVA);
        atualizacaoBinStep = new ProcessStep(7, processTypeVersion, ServiceType.ATUALIZACAO_BIN);
        atualizacaoSngStep = new ProcessStep(8, processTypeVersion, ServiceType.ATUALIZACAO_SNG);
        emissaoCrvCrlvStep = new ProcessStep(9, processTypeVersion, ServiceType.EMISSAO_CRV_CRLV);
        encerramentoStep = new ProcessStep(99, processTypeVersion, ServiceType.ENCERRAMENTO);

        aberturaProcessoStep.connectTo(vistoriaStep);
        vistoriaStep.connectTo(primeiroEmplacamentoStep, "Aprovada");
        vistoriaStep.connectTo(vistoriaStep, "Reprovada");

        primeiroEmplacamentoStep.connectTo(conferenciaStep);
        conferenciaStep.connectTo(primeiroEmplacamentoStep, "Reprovada");
        conferenciaStep.connectTo(bcvaStep, "Aprovada");
        conferenciaStep.connectTo(atualizacaoBinStep, "Aprovada");
        conferenciaStep.connectTo(atualizacaoSngStep, "Aprovada");

        bcvaStep.connectTo(emissaoCrvCrlvStep);
        atualizacaoBinStep.connectTo(emissaoCrvCrlvStep);
        atualizacaoSngStep.connectTo(emissaoCrvCrlvStep);

        emissaoCrvCrlvStep.connectTo(encerramentoStep);

        processTypeVersion.getSteps().add(aberturaProcessoStep);
        processTypeVersion.getSteps().add(vistoriaStep);
        processTypeVersion.getSteps().add(primeiroEmplacamentoStep);
        processTypeVersion.getSteps().add(conferenciaStep);
        processTypeVersion.getSteps().add(bcvaStep);
        processTypeVersion.getSteps().add(atualizacaoBinStep);
        processTypeVersion.getSteps().add(atualizacaoSngStep);
        processTypeVersion.getSteps().add(emissaoCrvCrlvStep);
        processTypeVersion.getSteps().add(encerramentoStep);
    }

    @Test
    public void test_openProcess() {

        ProcessInstance firstProcessInstance = openProcess();
        Process process = firstProcessInstance.getProcess();

        firstProcessInstance = reprovarVistoria(firstProcessInstance);
        firstProcessInstance = aprovarVistoria(firstProcessInstance);
        firstProcessInstance = primeiroEmplacamento(firstProcessInstance);
        firstProcessInstance = reprovarConferencia(firstProcessInstance);
        firstProcessInstance = primeiroEmplacamento(firstProcessInstance);
        firstProcessInstance = aprovarConferencia(firstProcessInstance);

        final ProcessInstance bcvaInstance = process.getActiveInstances().get(0);
        final ProcessInstance binInstance = process.getActiveInstances().get(1);
        final ProcessInstance sngInstance = process.getActiveInstances().get(2);

        Runnable r1 = new Runnable() {
            public void run() {
                emitirBcva(bcvaInstance);
            }
        };
        Runnable r2 = new Runnable() {
            public void run() {
                atualizarBin(binInstance);
            }
        };
        Runnable r3 = new Runnable() {
            public void run() {
                atualizarSng(sngInstance);
            }
        };

        new Thread(r1).start();
        new Thread(r2).start();
        new Thread(r3).start();

        ProcessInstance lastInstance = process.getActiveInstances().get(0);
        firstProcessInstance = emitirCrvCrlv(lastInstance);
        firstProcessInstance = encerrarProcesso(lastInstance);

        firstProcessInstance.toString();
    }

    private ProcessInstance openProcess() {
        ProcessInstance processInstance = processFacade.openProcess(processType, null);

        assertEquals(vistoriaStep, processInstance.getNextStep());
        assertEquals(1, processInstance.getProcess().getInstances().size());
        assertEquals(ProcessStatus.ABERTO, processInstance.getProcess().getStatus());
        assertEquals(processType.getCurrentVersion(), processInstance.getProcess().getType());
        return processInstance;
    }

    private ProcessInstance aprovarVistoria(ProcessInstance processInstance) {
        return executarServico(processInstance, Boolean.TRUE, primeiroEmplacamentoStep, 1, 0, ProcessStatus.ABERTO);
    }

    private ProcessInstance reprovarVistoria(ProcessInstance processInstance) {
        return executarServico(processInstance, Boolean.FALSE, vistoriaStep, 1, 0, ProcessStatus.ABERTO);
    }

    private ProcessInstance primeiroEmplacamento(ProcessInstance processInstance) {
        return executarServico(processInstance, UM_ED_QUALQUER, conferenciaStep, 1, 0, ProcessStatus.ABERTO);
    }

    private ProcessInstance reprovarConferencia(ProcessInstance processInstance) {
        return executarServico(processInstance, Boolean.FALSE, primeiroEmplacamentoStep, 1, 0, ProcessStatus.ABERTO);
    }

    private ProcessInstance aprovarConferencia(ProcessInstance processInstance) {
        return executarServico(processInstance, Boolean.TRUE, null, 3, 1, ProcessStatus.ABERTO);
    }

    private ProcessInstance emitirBcva(ProcessInstance processInstance) {
        return executarServico(processInstance, UM_ED_QUALQUER, null, 2, 2, ProcessStatus.ABERTO);
    }

    private ProcessInstance atualizarBin(ProcessInstance processInstance) {
        return executarServico(processInstance, UM_ED_QUALQUER, null, 1, 3, ProcessStatus.ABERTO);
    }

    private ProcessInstance atualizarSng(ProcessInstance processInstance) {
        return executarServico(processInstance, UM_ED_QUALQUER, emissaoCrvCrlvStep, 1, 3, ProcessStatus.ABERTO);
    }

    private ProcessInstance emitirCrvCrlv(ProcessInstance processInstance) {
        return executarServico(processInstance, UM_ED_QUALQUER, encerramentoStep, 1, 3, ProcessStatus.ABERTO);
    }

    private ProcessInstance encerrarProcesso(ProcessInstance processInstance) {
        return executarServico(processInstance, UM_ED_QUALQUER, null, 0, 4, ProcessStatus.ENCERRADO);
    }

    private <T> ProcessInstance executarServico(ProcessInstance processInstance, T payload, ProcessStep expectedNextStep, int expectedActiveInstances,
            int expectedInactiveInstances, ProcessStatus expectedStatus) {
        processInstance = processFacade.executeService(processInstance, payload);

        // assertEquals(expectedNextStep, processInstance.getNextStep());
        // assertEquals(expectedActiveInstances,
        // processInstance.getProcess().getActiveInstances().size());
        // assertEquals(expectedInactiveInstances,
        // processInstance.getProcess().getInactiveInstances().size());
        // assertEquals(expectedStatus, processInstance.getProcess().getStatus());
        return processInstance;
    }

}
