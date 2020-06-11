package org.metaworks.metadata;

import java.util.ArrayList;

import org.metaworks.annotation.Face;

@Face(ejsPath="dwr/metaworks/genericfaces/CleanObjectFace.ejs"  , options={"disableHeight"}, values={"true"})
public class ProcessPropertyPanel {
	
	ArrayList<ProcessProperty> processProperties;
		public ArrayList<ProcessProperty> getProcessProperties() {
			return processProperties;
		}	
		public void setProcessProperties(ArrayList<ProcessProperty> processProperties) {
			this.processProperties = processProperties;
		}

	public ProcessPropertyPanel() {		
	}
	
	public ProcessPropertyPanel(ArrayList<ProcessProperty> processProperties) {
		this.setProcessProperties(processProperties);
	}

}
