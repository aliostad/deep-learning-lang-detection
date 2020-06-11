package no.hal.eclipsky.services.workspace.http;

import no.hal.eclipsky.services.workspace.WorkspaceService;

@SuppressWarnings("serial")
public abstract class AbstractWorkspaceServiceServlet extends AbstractServiceServlet implements WorkspaceServiceServlet {

	private WorkspaceService workspaceService;

	protected WorkspaceService getWorkspaceService() {
		return workspaceService;
	}

	public synchronized void setWorkspaceService(WorkspaceService workspaceService) {
		this.workspaceService = workspaceService;
	}
}
