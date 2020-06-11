package com.ynov.test.exam.partie3;

import org.junit.Test;

import static org.junit.Assert.*;

public class QueueProcessManagerTest extends ProcessManagerTest {

    @Override
    protected ProcessManager createProcessManager() {
        return new QueueProcessManager();
    }

    @Test
    public void testYieldProcess() {
        //Etant donné un gestionnaire de processus contenant, par ordre d'insertion, p1, p2, p3
        MyProcess p1 = new MyProcess("0001", 0);
        MyProcess p2 = new MyProcess("0002", 0);
        MyProcess p3 = new MyProcess("0003", 0);
        processManager.queueProcess(p1);
        processManager.queueProcess(p2);
        processManager.queueProcess(p3);

        //Lorsque je retire un processus
        //Alors j'obtiens p1
        assertEquals(p1, processManager.yieldProcess());
        //Puis p2
        assertEquals(p2, processManager.yieldProcess());
        //Puis p3
        assertEquals(p3, processManager.yieldProcess());
        assertEquals(null, processManager.yieldProcess());
    }
}