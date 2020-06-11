package de.gravitex.processing;

import de.gravitex.processing.core.ProcessEngine;
import de.gravitex.processing.core.ProcessItemFactory;
import de.gravitex.processing.core.item.ProcessItem;
import de.gravitex.processing.core.item.ProcessItemType;

public class ProcessDefinitionProvider {

	public static ProcessEngine getApplianceProcess() {

		ProcessEngine processContainer = new ProcessEngine();
		// action
		ProcessItem delData1 = ProcessItemFactory.getProcessElement(ProcessItemType.ACTION, "delData1", null);
		processContainer.addElement(delData1);
		ProcessItem delData2 = ProcessItemFactory.getProcessElement(ProcessItemType.ACTION, "delData2", null);
		processContainer.addElement(delData2);
		ProcessItem revoke = ProcessItemFactory.getProcessElement(ProcessItemType.ACTION, "revoke", null);
		processContainer.addElement(revoke);
		ProcessItem acknowledgeData = ProcessItemFactory.getProcessElement(ProcessItemType.ACTION, "acknowledgeData", null);
		processContainer.addElement(acknowledgeData);
		ProcessItem infoMail = ProcessItemFactory.getProcessElement(ProcessItemType.ACTION, "infoMail", null);
		processContainer.addElement(infoMail);
		ProcessItem confStoreData = ProcessItemFactory.getProcessElement(ProcessItemType.ACTION, "confStoreData", null);
		processContainer.addElement(confStoreData);
		ProcessItem ackNoStorage = ProcessItemFactory.getProcessElement(ProcessItemType.ACTION, "ackNoStorage", null);
		processContainer.addElement(ackNoStorage);
		ProcessItem askStoreData = ProcessItemFactory.getProcessElement(ProcessItemType.ACTION, "askStoreData", null);
		processContainer.addElement(askStoreData);

		// task
		ProcessItem gatherData = ProcessItemFactory.getProcessElement(ProcessItemType.TASK, "gatherData", null);
		processContainer.addElement(gatherData);
		ProcessItem sightData = ProcessItemFactory.getProcessElement(ProcessItemType.TASK, "sightData", null);
		processContainer.addElement(sightData);
		ProcessItem appoint = ProcessItemFactory.getProcessElement(ProcessItemType.TASK, "appoint", null);
		processContainer.addElement(appoint);
		ProcessItem writeHrDB = ProcessItemFactory.getProcessElement(ProcessItemType.TASK, "writeHrDB", null);
		processContainer.addElement(writeHrDB);
		ProcessItem storePotDB = ProcessItemFactory.getProcessElement(ProcessItemType.TASK, "storePotDB", null);
		processContainer.addElement(storePotDB);
		ProcessItem storeAnswer = ProcessItemFactory.getProcessElement(ProcessItemType.TASK, "storeAnswer", null);
		processContainer.addElement(storeAnswer);

		// timer
		ProcessItem timer1 = ProcessItemFactory.getProcessElement(ProcessItemType.WAIT, "timer1", null);
		processContainer.addElement(timer1);

		// join
		ProcessItem join1 = ProcessItemFactory.getProcessElement(ProcessItemType.JOIN, "join1", null);
		processContainer.addElement(join1);
		ProcessItem join2 = ProcessItemFactory.getProcessElement(ProcessItemType.JOIN, "join2", null);
		processContainer.addElement(join2);

		// fork
		ProcessItem fork1 = ProcessItemFactory.getProcessElement(ProcessItemType.FORK, "fork1", null);
		processContainer.addElement(fork1);
		ProcessItem fork2 = ProcessItemFactory.getProcessElement(ProcessItemType.FORK, "fork2", null);
		processContainer.addElement(fork2);
		ProcessItem fork3 = ProcessItemFactory.getProcessElement(ProcessItemType.FORK, "fork3", null);
		processContainer.addElement(fork3);
		ProcessItem fork4 = ProcessItemFactory.getProcessElement(ProcessItemType.FORK, "fork4", null);
		processContainer.addElement(fork4);

		// start
		ProcessItem start = ProcessItemFactory.getProcessElement(ProcessItemType.START, "start", null);
		processContainer.addElement(start);

		// end
		ProcessItem end1 = ProcessItemFactory.getProcessElement(ProcessItemType.END, "end1", null);
		processContainer.addElement(end1);
		ProcessItem end2 = ProcessItemFactory.getProcessElement(ProcessItemType.END, "end2", null);
		processContainer.addElement(end2);
		ProcessItem end3 = ProcessItemFactory.getProcessElement(ProcessItemType.END, "end3", null);
		processContainer.addElement(end3);
		ProcessItem end4 = ProcessItemFactory.getProcessElement(ProcessItemType.END, "end4", null);
		processContainer.addElement(end4);

		// relations
		/* 01 */processContainer.relateParentFromTo("revoke", "end1");
		/* 02 */processContainer.relateParentFromTo("delData1", "revoke");
		/* 03 */processContainer.relateParentFromTo("join1", "delData1");
		/* 04 */processContainer.relateParentFromTo("fork1", "join1");

		/* 06 */processContainer.relateParentFromTo("fork4", "join1");
		/* 07 */processContainer.relateParentFromTo("fork2", "fork4");
		/* 08 */processContainer.relateParentFromTo("fork2", "writeHrDB");
		/* 09 */processContainer.relateParentFromTo("writeHrDB", "infoMail");
		/* 10 */processContainer.relateParentFromTo("infoMail", "end2");
		/* 11 */processContainer.relateParentFromTo("fork1", "join2");
		/* 12 */processContainer.relateParentFromTo("fork1", "askStoreData");
		/* 13 */processContainer.relateParentFromTo("sightData", "fork1");
		/* 14 */processContainer.relateParentFromTo("acknowledgeData", "sightData");
		/* 15 */processContainer.relateParentFromTo("gatherData", "acknowledgeData");
		/* 16 */processContainer.relateParentFromTo("start", "gatherData");
		/* 17 */processContainer.relateParentFromTo("askStoreData", "storeAnswer");
		/* 18 */processContainer.relateParentFromTo("storeAnswer", "fork3");
		/* 19 */processContainer.relateParentFromTo("fork3", "ackNoStorage");
		/* 20 */processContainer.relateParentFromTo("fork3", "confStoreData");
		/* 21 */processContainer.relateParentFromTo("ackNoStorage", "delData2");
		/* 22 */processContainer.relateParentFromTo("confStoreData", "storePotDB");
		/* 23 */processContainer.relateParentFromTo("delData2", "end3");
		/* 24 */processContainer.relateParentFromTo("storePotDB", "end4");
		/* 25 */processContainer.relateParentFromTo("timer1", "join2");
		/* 26 */processContainer.relateParentFromTo("join2", "appoint");
		/* 27 */processContainer.relateParentFromTo("appoint", "fork2");

		/* 99 */processContainer.relateParentFromTo("fork4", "timer1");

		// resolve
		/*
		 * processContainer.addTaskResolver("gatherData",
		 * GenericTrueResolver.class);
		 * processContainer.addTaskResolver("sightData",
		 * GenericTrueResolver.class);
		 * processContainer.addTaskResolver("appoint",
		 * GenericTrueResolver.class);
		 * processContainer.addTaskResolver("writeHrDB",
		 * GenericTrueResolver.class);
		 * processContainer.addTaskResolver("storePotDB",
		 * GenericTrueResolver.class);
		 * processContainer.addTaskResolver("storeAnswer",
		 * GenericTrueResolver.class);
		 */

		return processContainer;
	}
}