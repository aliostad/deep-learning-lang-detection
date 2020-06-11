package fr.opensagres.xdocreport.admin.eclipse.ui.views;

import org.eclipse.jface.action.Action;

import fr.opensagres.xdocreport.admin.eclipse.core.Repository;

public class OpenEditorAction extends Action {

	private final RepositoryExplorer repositoryExplorer;
	private final Repository repository;
	private final Object element;

	public OpenEditorAction(RepositoryExplorer repositoryExplorer,
			Repository repository, Object element) {
		this.repositoryExplorer = repositoryExplorer;
		this.repository = repository;
		this.element = element;
		super.setText("Open");
	}

	@Override
	public void run() {
		repositoryExplorer.openEditor(repository, element);
	}
}
