package org.uengine.codi.mw3.webProcessDesigner;

import org.metaworks.Refresh;
import org.metaworks.annotation.AutowiredFromClient;
import org.uengine.codi.mw3.model.Session;
import org.uengine.codi.mw3.processexplorer.ProcessExploreWindow;
import org.uengine.codi.mw3.processexplorer.ProcessNameView;
import org.uengine.codi.mw3.processexplorer.ViewContentWindow;

public class ProcessViewWindow {

	String defId;
		public String getDefId() {
			return defId;
		}
		public void setDefId(String defId) {
			this.defId = defId;
		}
	String alias;
		public String getAlias() {
			return alias;
		}
		public void setAlias(String alias) {
			this.alias = alias;
		}
		
	String path;
		public String getPath() {
			return path;
		}
		public void setPath(String path) {
			this.path = path;
		}
	ProcessNavigatorPanel processNavigatorPanel;
		public ProcessNavigatorPanel getProcessNavigatorPanel() {
			return processNavigatorPanel;
		}
		public void setProcessNavigatorPanel(ProcessNavigatorPanel processNavigatorPanel) {
			this.processNavigatorPanel = processNavigatorPanel;
		}
	ProcessViewPanel processViewPanel;
		public ProcessViewPanel getProcessViewPanel() {
			return processViewPanel;
		}
		public void setProcessViewPanel(ProcessViewPanel processViewPanel) {
			this.processViewPanel = processViewPanel;
		}

	ProcessNameView processNameView;
		public ProcessNameView getProcessNameView() {
			return processNameView;
		}
		public void setProcessNameView(ProcessNameView processNameView) {
			this.processNameView = processNameView;
		}	
		
	public ProcessViewWindow() throws Exception{
		processNavigatorPanel = new ProcessNavigatorPanel();
		processViewPanel = new ProcessViewPanel();
		processNameView = new ProcessNameView();
	}
	
	@AutowiredFromClient
	transient public Session session;
		
	//DefinitionViewWindow의 Layout Setting
	public void load() throws Exception{
		if( alias != null){

			processNavigatorPanel.setDefId(this.getDefId());
			processNavigatorPanel.setAlias(this.getAlias());
			processNavigatorPanel.load();
			
			
			processViewPanel.setDefId(this.getDefId());
			processViewPanel.setAlias(this.getAlias());
			processViewPanel.setViewType("definitionView");
			processViewPanel.load();
			
			processNameView.setFileId(this.getDefId());
			if( processViewPanel != null && processViewPanel.getProcessViewer() != null){
				processNameView.setAlias(processViewPanel.getProcessViewer().getTitle());
			}else{
				processNameView.setAlias(this.getAlias());
			}
			
			processNameView.session = session;
			processNameView.load();
			
//			processAttributePanel.setDocumentation(null);
//			processAttributePanel.setDefId(defId);
//			
//			
//			if( processViewPanel.processViewer != null ){
//				processAttributePanel.load(processViewPanel.processViewer.getProcessDesignerContainer());
//			}
		}
	}
	
	public void loadByProcess(HistoryItem historyItem) throws Exception{
		
		processNavigatorPanel.historyList.add(historyItem);
		
		processViewPanel = new ProcessViewPanel();
		processViewPanel.setDefId(historyItem.getDefId());
		processViewPanel.setAlias(historyItem.getAlias());
		processViewPanel.setViewType("definitionView");
		processViewPanel.load();
		
//		processAttributePanel.setDocumentation(null);
//		processAttributePanel.setDefId(historyItem.getDefId());
//		if( processViewPanel.processViewer != null ){
//			processAttributePanel.load(processViewPanel.processViewer.getProcessDesignerContainer());
//		}
		
	}
	public  Object[] loadFile(Session session, String fileId, String fileName,String filePath,String title) throws Exception{
		
		this.setAlias(fileName);
		this.setDefId(fileId);
		this.setPath(filePath);
		this.session = session;
		this.load();
		
		ProcessExploreWindow processExploreWindow = new ProcessExploreWindow();
		processExploreWindow.setPanel(this);
		processExploreWindow.setTitle(title);
	
		ViewContentWindow viewContentWindow = new ViewContentWindow();
		viewContentWindow.setPanel(null);
		
		return new Object[]{new Refresh(processExploreWindow), new Refresh(viewContentWindow)};
		
	}
}
