package org.kompiro.jamcircle.xmpp.kanban.ui.internal;

import org.kompiro.jamcircle.kanban.service.KanbanService;
import org.kompiro.jamcircle.xmpp.service.XMPPConnectionService;

public class XMPPKanbanUIContext {

	private static XMPPKanbanUIContext context;
	private KanbanService kanbanService;
	private XMPPConnectionService xmppConnectionService;
	
	public XMPPKanbanUIContext() {
		XMPPKanbanUIContext.context = this;
	}
	
	public KanbanService getKanbanService() {
		return kanbanService;
	}

	public void setKanbanService(KanbanService kanbanService) {
		this.kanbanService = kanbanService;
	}

	public XMPPConnectionService getXMPPConnectionService() {
		return xmppConnectionService;
	}

	public void setXMPPConnectionService(XMPPConnectionService xmppConnectionService) {
		this.xmppConnectionService = xmppConnectionService;
	}

	public static XMPPKanbanUIContext getDefault(){
		return XMPPKanbanUIContext.context;
	}
	
}
