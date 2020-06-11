package edu.kit.ipd.sdq.kamp.core;

import java.util.List;

import org.eclipse.emf.ecore.util.EcoreUtil;

import de.uka.ipd.sdq.componentInternalDependencies.ComponentInternalDependencyRepository;
import de.uka.ipd.sdq.pcm.repository.Repository;
import de.uka.ipd.sdq.pcm.system.System;
import edu.kit.ipd.sdq.kamp.model.fieldofactivityannotations.FieldOfActivityAnnotationRepository;
import edu.kit.ipd.sdq.kamp.model.modificationmarks.ModificationRepository;

public class ArchitectureVersion {
	private String name;
	private Repository repository;
	private de.uka.ipd.sdq.pcm.system.System system;
	private FieldOfActivityAnnotationRepository fieldOfActivityRepository;
	private ModificationRepository modificationMarkRepository;
	private ComponentInternalDependencyRepository componentInternalDependencyRepository;
	
	private List<Activity> activityList;
	
	public ArchitectureVersion(
			String name,
			Repository repository,
			System system,
			FieldOfActivityAnnotationRepository fieldOfActivityRepository,
			ModificationRepository internalModificationMarkRepository,
			ComponentInternalDependencyRepository componentInternalDependencyRepository) {
		super();
		this.name = name;
		this.repository = repository;
		this.system = system;
		this.fieldOfActivityRepository = fieldOfActivityRepository;
		this.modificationMarkRepository = internalModificationMarkRepository;
		this.componentInternalDependencyRepository = componentInternalDependencyRepository;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Repository getRepository() {
		return repository;
	}

	public void setRepository(Repository repository) {
		this.repository = repository;
	}

	public de.uka.ipd.sdq.pcm.system.System getSystem() {
		return system;
	}

	public void setSystem(de.uka.ipd.sdq.pcm.system.System system) {
		this.system = system;
	}

	public FieldOfActivityAnnotationRepository getFieldOfActivityRepository() {
		return fieldOfActivityRepository;
	}

	public void setFieldOfActivityRepository(
			FieldOfActivityAnnotationRepository fieldOfActivityRepository) {
		this.fieldOfActivityRepository = fieldOfActivityRepository;
	}

	public ModificationRepository getModificationMarkRepository() {
		return modificationMarkRepository;
	}

	public void setInternalModificationMarkRepository(
			ModificationRepository internalModificationMarkRepository) {
		this.modificationMarkRepository = internalModificationMarkRepository;
	}

	public ComponentInternalDependencyRepository getComponentInternalDependencyRepository() {
		return componentInternalDependencyRepository;
	}

	public void setComponentInternalDependencyRepository(
			ComponentInternalDependencyRepository componentInternalDependencyRepository) {
		this.componentInternalDependencyRepository = componentInternalDependencyRepository;
	}
	
	public List<Activity> getActivityList() {
		return activityList;
	}

	public void setActivityList(List<Activity> activityList) {
		this.activityList = activityList;
	}

	public void delete() {
		EcoreUtil.delete(this.getRepository(), true);
		EcoreUtil.delete(this.getSystem(), true);
		EcoreUtil.delete(this.getFieldOfActivityRepository(), true);
		EcoreUtil.delete(this.getModificationMarkRepository(), true);
		EcoreUtil.delete(this.getComponentInternalDependencyRepository(), true);
	}

}
