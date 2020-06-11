package cn.edu.pku.ss.matchmaker.adapter;

import EDU.cmu.Atlas.owls1_1.process.Process;
import EDU.cmu.Atlas.owls1_1.profile.Profile;

public class OWLSQueryData {
	private Profile profile;
	private Process process;
	
	public OWLSQueryData() {
		// TODO Auto-generated constructor stub
	}
	
	public OWLSQueryData(Profile profile, Process process) {
		this.profile = profile;
		this.process = process;
	}

	public Profile getProfile() {
		return profile;
	}

	public void setProfile(Profile profile) {
		this.profile = profile;
	}

	public Process getProcess() {
		return process;
	}

	public void setProcess(Process process) {
		this.process = process;
	}
}
