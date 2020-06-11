package ro.endava.hackathon.service;

import java.util.ArrayList;
import java.util.List;

import ro.endava.hackathon.Configuration;
import ro.endava.hackathon.core.Activity;
import ro.endava.hackathon.core.Person;
import ro.endava.hackathon.core.ProcessActivity;
import ro.endava.hackathon.core.ProcessPerson;

public class InitializationService {
	public static List<ProcessActivity> prepareProcessActivitiesFromActivities(List<Activity> activities) {
		if (Configuration.LOG) {
			System.out.println("Initializare processActivities...");
		}
		List<ProcessActivity> processActivities = new ArrayList<ProcessActivity>();
		for (Activity currentActivity : activities) {
			ProcessActivity processActivity = new ProcessActivity();
			processActivity.setActivity(currentActivity);
			processActivity.setWorking(true);
			processActivity.setRemainingHours(currentActivity.getContinuousOpenHours());
			processActivity.setPersonsAttending(null);
			processActivities.add(processActivity);
		}
		return processActivities;
	}

	public static List<ProcessPerson> prepareProcessPersonsFromPersons(List<Person> persons) {
		if (Configuration.LOG) {
			System.out.println("Initializare ProcessPerson...");
		}
		List<ProcessPerson> processPersons = new ArrayList<ProcessPerson>();
		for (Person currentPerson : persons) {
			ProcessPerson processPerson = new ProcessPerson();
			processPerson.setPerson(currentPerson);
			processPerson.setAwake(true);
			processPerson.setRemainingBudget(currentPerson.getBudget());
			processPerson.setRemainingHours(currentPerson.getMaxAwakeTime());
			processPerson.setAssigned(false);
			processPerson.setAssignedToProcessActivity(null);
			processPersons.add(processPerson);
		}
		return processPersons;
	}
}
