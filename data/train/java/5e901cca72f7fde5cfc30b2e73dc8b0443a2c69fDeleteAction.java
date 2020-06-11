package fr.opensagres.xdocreport.admin.eclipse.ui.views;

import org.eclipse.jface.action.Action;

import fr.opensagres.xdocreport.admin.eclipse.core.Repository;

public class DeleteAction extends Action {

	private final RepositoryExplorer repositoryExplorer;

	public DeleteAction(RepositoryExplorer repositoryExplorer) {
		this.repositoryExplorer = repositoryExplorer;
		super.setText("Delete");
	}

	@Override
	public void run() {
		Repository selectedRepository = (Repository)repositoryExplorer.getFirstSelectedElement();
		repositoryExplorer.getRepositoryManager().removeRepository(selectedRepository);
		repositoryExplorer.getViewer().remove(
				selectedRepository);
	}
	
}
