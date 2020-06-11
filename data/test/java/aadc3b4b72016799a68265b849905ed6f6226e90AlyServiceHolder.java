package ru.acs.fts.aly.router.model;

import org.springframework.beans.factory.annotation.Required;

import ru.acs.fts.aly.model.services.DiffService;
import ru.acs.fts.aly.model.services.MessageService;
import ru.acs.fts.eps2.model.services.EnvelopeService;
import ru.acs.fts.eps2.model.services.ServiceHolder;

public class AlyServiceHolder extends ServiceHolder
{
	// aly
	
	private MessageService _messageService;
	private DiffService _diffService;
	
	// eps
	
	private EnvelopeService _envelopeService;
	
	// @formatter:off
	@Required public void setMessageService( MessageService messageService ) { _messageService = messageService; }
	public MessageService getMessageService( ) { return _messageService; }
	
	@Required public void setDiffService( DiffService diffService ) { _diffService = diffService; }
	public DiffService getDiffService( ) { return _diffService; }
	
	@Required public void setEnvelopeService( EnvelopeService envelopeService ) { _envelopeService = envelopeService; }
	public EnvelopeService getEnvelopeService( ) { return _envelopeService; }
	// @formatter:on
}
