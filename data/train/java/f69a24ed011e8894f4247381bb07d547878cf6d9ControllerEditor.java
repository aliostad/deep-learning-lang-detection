package de.rincewind.gui.controller.abstracts;

import de.rincewind.api.abstracts.Dataset;
import de.rincewind.gui.util.SaveHandler;
import de.rincewind.gui.util.TabHandler;

public abstract class ControllerEditor implements Controller {
	
	private TabHandler handler;
	
	private SaveHandler saveHandler;
	
	public ControllerEditor(TabHandler handler) {
		this.saveHandler = new SaveHandler();
		this.handler = handler;
	}
	
	public abstract void saveStages();
	
	public abstract Dataset getEditingObject();
	
	public TabHandler getTabHandler() {
		return this.handler;
	}
	
	public SaveHandler getSaveHandler() {
		return this.saveHandler;
	}
	
}
