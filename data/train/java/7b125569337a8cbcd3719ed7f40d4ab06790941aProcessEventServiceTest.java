package it.webscience.kpeople.service.report;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import org.junit.Test;

import it.webscience.kpeople.service.datatypes.ProcessEvent;


public class ProcessEventServiceTest {
    
    @Test
    public void testGetProcessEvent() {

        try {
            ProcessEventService service = new ProcessEventService();
            ProcessEvent[] processEventList = service.getProcessEvents();
            ProcessEvent processEvent = new ProcessEvent();
            processEvent = processEventList[0];
            assertTrue(processEvent.getHpmProcessId().equals("rda1185"));
            assertTrue(processEvent.getHpmEventId().equalsIgnoreCase("5emailserver.POSTFIX.systemId@3007@2011-03-03 21:56:48.0"));
        } catch (Exception e) {
            e.printStackTrace();
            fail();
        }
    }

}
