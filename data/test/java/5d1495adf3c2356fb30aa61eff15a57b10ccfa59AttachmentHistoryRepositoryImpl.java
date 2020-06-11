package it.hellokitty.gt.bulletin.repository.impl;

import it.ferrari.gt.repository.utils.RepositoryUtils;
import it.hellokitty.gt.bulletin.entity.AttachmentHistory;
import it.hellokitty.gt.bulletin.repository.AttachmentHistoryRepository;

public class AttachmentHistoryRepositoryImpl extends RepositoryUtils<AttachmentHistory> implements AttachmentHistoryRepository{
	{
		persistenceUnitName = "BULLETIN_PU";
		typeParameterClass = AttachmentHistory.class;
	}
	
	public AttachmentHistoryRepositoryImpl(){
		super();
	}
}
