package com.turpgames.framework.v0.impl;

import java.util.ArrayList;
import java.util.List;

import com.turpgames.framework.v0.IUpdateProcess;
import com.turpgames.framework.v0.util.Game;
import com.turpgames.framework.v0.util.Version;

public final class UpdateProcessor {
	public static final UpdateProcessor instance = new UpdateProcessor();

	private List<IUpdateProcess> processList = new ArrayList<IUpdateProcess>();
	private final Version lastUpdateProcessVersion;
	
	private UpdateProcessor() {
		lastUpdateProcessVersion = new Version(Settings.getString("last-update-process-version", "0.0"));
	}

	public void execute() {		
		for (IUpdateProcess process : processList) {
			if (process.getVersion().compareTo(lastUpdateProcessVersion) > 0)
				process.execute();
		}
		
		Settings.putString("last-update-process-version", Game.getVersion().toString());
	}

	public void addProcess(IUpdateProcess process) {
		if (process.getVersion().compareTo(lastUpdateProcessVersion) < 1)
			return;
		
		int i;
		for (i = 0; i < processList.size(); i++) {
			if (processList.get(i).getVersion().compareTo(process.getVersion()) == 1)
				break;
		}
		processList.add(i, process);
	}
}
