package ro.endava.hackathon.service;

import java.util.ArrayList;
import java.util.List;

import ro.endava.hackathon.Configuration;
import ro.endava.hackathon.core.ProcessActivity;
import ro.endava.hackathon.core.ProcessPerson;

public class UpdateService {
	public static void updateProcessActivityAtEndOfHour(List<ProcessActivity> processActivities) {
		if (Configuration.LOG) {
			System.out.println("Se actualizeaza activitatile la sfarsitul orei...");
		}
		for (ProcessActivity processActivity : processActivities) {
			if (processActivity.getRemainingHours() > 1) {
				processActivity.setRemainingHours(processActivity.getRemainingHours() - 1);
			} else {
				processActivity.setWorking(!processActivity.getWorking());
				processActivity.setRemainingHours(processActivity.getWorking() ? processActivity.getActivity().getContinuousOpenHours() : processActivity.getActivity().getMaintenanceHours());
			}
			processActivity.setPersonsAttending(new ArrayList<ProcessPerson>());
		}
	}
	
	public static void updateProcessPersonAtEndOfHour(List<ProcessPerson> processPersons) {
		if (Configuration.LOG) {
			System.out.println("Se actualizeaza persoanele la sfarsitul orei...");
		}
		for (ProcessPerson processPerson : processPersons) {
			if (processPerson.getRemainingHours() > 1) {
				processPerson.setRemainingHours(processPerson.getRemainingHours() - 1);
			} else {
				processPerson.setAwake(!processPerson.getAwake());
				processPerson.setRemainingHours(processPerson.getAwake() ? processPerson.getPerson().getMaxAwakeTime() : processPerson.getPerson().getContinuousSleepTime());
			}
			processPerson.setAssigned(false);
			processPerson.setAssignedToProcessActivity(null);
		}
	}
}
