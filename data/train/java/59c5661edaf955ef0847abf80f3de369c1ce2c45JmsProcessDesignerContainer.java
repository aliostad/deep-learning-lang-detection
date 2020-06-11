package org.uengine.jms.mw3.model;

import org.uengine.codi.mw3.webProcessDesigner.ProcessDesignerContainer;
import org.uengine.kernel.ProcessDefinition;
import org.uengine.kernel.ValueChainDefinition;

public class JmsProcessDesignerContainer extends ProcessDesignerContainer {

	ProcessDetailPanel processDetailPanel;
		public ProcessDetailPanel getProcessDetailPanel() {
			return processDetailPanel;
		}
		public void setProcessDetailPanel(ProcessDetailPanel processDetailPanel) {
			this.processDetailPanel = processDetailPanel;
		}
	ProcessSummaryPanel processSummaryPanel;
		public ProcessSummaryPanel getProcessSummaryPanel() {
			return processSummaryPanel;
		}
		public void setProcessSummaryPanel(ProcessSummaryPanel processSummaryPanel) {
			this.processSummaryPanel = processSummaryPanel;
		}
	
	@Override
	public void init(){
		super.init();
		
		processDetailPanel = new ProcessDetailPanel();
		processSummaryPanel = new ProcessSummaryPanel();
	}
	
	@Override
	public void load(ProcessDefinition def) throws Exception{
		processDetailPanel.setEditorId(this.getEditorId());
		processSummaryPanel.setEditorId(this.getEditorId());
		
		super.load(def);
		
		processDetailPanel.load(def.getDocumentation());
	}
	@Override
	public void loadValueChain(ValueChainDefinition def) throws Exception{
		processDetailPanel.setEditorId(this.getEditorId());
		processSummaryPanel.setEditorId(this.getEditorId());
		super.loadValueChain(def);
	}
	
	@Override
	public ProcessDefinition containerToDefinition(ProcessDesignerContainer container) throws Exception{
		ProcessDefinition def = super.containerToDefinition(container);
		def.setDocumentation(processDetailPanel.getDocumentation());
		return def;
	}
}
