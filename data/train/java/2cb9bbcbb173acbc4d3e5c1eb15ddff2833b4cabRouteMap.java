package br.com.portalfeec.model;

public class RouteMap extends AuditEntity {

	private Decision decision;
	private ProcessStep currentProcessStep;
	private ProcessStep nextProcessStep;
	
	
	public Decision getDecision() {
		return decision;
	}
	public void setDecision(Decision decision) {
		this.decision = decision;
	}
	public ProcessStep getCurrentProcessStep() {
		return currentProcessStep;
	}
	public void setCurrentProcessStep(ProcessStep currentProcessStep) {
		this.currentProcessStep = currentProcessStep;
	}
	public ProcessStep getNextProcessStep() {
		return nextProcessStep;
	}
	public void setNextProcessStep(ProcessStep nextProcessStep) {
		this.nextProcessStep = nextProcessStep;
	}
}
