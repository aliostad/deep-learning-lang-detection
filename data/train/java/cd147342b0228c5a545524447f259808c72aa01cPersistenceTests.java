package com.rhiscom.vigia.tests;

import org.junit.Test;

import com.rhiscom.vigia.ejb.VigiaEventMDB;
import com.rhiscom.vigia.events.ProcessMessage;

public class PersistenceTests {

	@Test
	public void saveProcessMessage() {
		ProcessMessage processMessage = new ProcessMessage();

		processMessage.setOperatorMessageCode("009");
		processMessage.setProcessCode("PROC001");
		processMessage.setProcessState(ProcessMessage.PROCESS_STATE_ERROR);
		processMessage.setProcessText("PROCESO 1");

		VigiaEventMDB mdb = new VigiaEventMDB();
		mdb.persistProcessMessage(processMessage);
	}

}
