/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.hsos.richwps.mb.processProvider.control;

import de.hsos.richwps.mb.entity.ProcessEntity;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author dziegenh
 */
public class ProcessCacheTest {

    private ProcessCache instance;

    private final String PROCESS_SERVER = "P_SERVER";
    private final String PROCESS_IDENTIFIER = "P_IDENTIFIER";

    public ProcessCacheTest() {
    }

    @Before
    public void setUp() {
        this.instance = new ProcessCache();
    }

    @Test
    public void testAddAndGetProcess() {
        ProcessEntity process = createTestProcess();
        assertTrue(this.instance.addProcess(process, false));

        ProcessEntity cached = this.instance.getCachedProcess(this.PROCESS_SERVER, this.PROCESS_IDENTIFIER);
        assertEquals(process, cached);
    }

    @Test
    public void testSetLoadingStatus() {
        ProcessEntity process = createTestProcess();
        this.instance.addProcess(process, false);

        assertFalse(this.instance.isLoaded(this.PROCESS_SERVER, this.PROCESS_IDENTIFIER));
        
        this.instance.setIsLoaded(this.PROCESS_SERVER, this.PROCESS_IDENTIFIER, true);
        assertTrue(this.instance.isLoaded(this.PROCESS_SERVER, this.PROCESS_IDENTIFIER));

        this.instance.setIsLoaded(this.PROCESS_SERVER, this.PROCESS_IDENTIFIER, false);
        assertFalse(this.instance.isLoaded(this.PROCESS_SERVER, this.PROCESS_IDENTIFIER));
    }

    private ProcessEntity createTestProcess() {
        return new ProcessEntity(this.PROCESS_SERVER, this.PROCESS_IDENTIFIER);
    }

    @Test
    public void testUpdateCachedProcess() {
        String processBTitle = "TITLE B";
        
        ProcessEntity ProcessA = createTestProcess();
        ProcessEntity ProcessB = createTestProcess();
        ProcessB.setOwsTitle(processBTitle);
        
        this.instance.addProcess(ProcessA, false);
        this.instance.addProcess(ProcessB, false);
        
        ProcessEntity cached = this.instance.getCachedProcess(this.PROCESS_SERVER, this.PROCESS_IDENTIFIER);
        assertEquals(System.identityHashCode(ProcessA), System.identityHashCode(cached));
        assertNotEquals(System.identityHashCode(ProcessB), System.identityHashCode(cached));
        assertEquals(ProcessA, cached);
        assertEquals(cached.getOwsTitle(), processBTitle);
    }
    
}
