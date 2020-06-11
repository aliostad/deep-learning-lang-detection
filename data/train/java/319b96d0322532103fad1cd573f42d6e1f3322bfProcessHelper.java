package com.sc.ws;

import com.sc.model.RequestData;
import com.sc.model.ResponseData;
import com.sc.service.ProcessFactory;
import com.sc.service.Process;
public class ProcessHelper
{
	private RequestData data;
	private  Process process;
	
	public ProcessHelper(RequestData data)
	{
		process=ProcessFactory.getProcess(data);
		this.data=data;
	}
	
	
	public ResponseData getProcessResponse()
	{
		int type=data.getType();
		
		switch (type) {
		
		case 0: 
			return process.processPendingMessages();
            
		case 1: 
			return process.processRegistration();
            
		case 2:
			return process.processSMSCodeRequest();
            
		case 3:
			return process.processSMSCodeValidate(data);
            
		case 4: 
			return process.processInviteRequest(data);
            
		case 5: 
			return process.processInviteRecipientResponse(data);
            
		case 6: 
			return process.processInviteInitiatorResponse(data);
            
		case 7: 
			return process.processSendMessage(data);
            
		case 8: 
			return process.processFetchMessage(data);
            
		case 9: 
			return process.processDeleteRequest(data);
            
		case 10: 
			return process.processUpdatePublicKey(data);
            
		case 12: 
			return process.processUpdatePushID(data);
            
		case 13: 
			return process.processDeleteContact(data);
            
		case 14: 
			return process.processDeleteContactResponse(data);
            
		case 15: 
			return process.processMessageAcknowledgement(data);
            
		case 16: 
			return process.processDeleteResponse(data);
            
		case 17: 
			return process.processDeleteAcknowledgement(data);
            
		case 18: 
			return process.processLicenseCheck(data);
            
		case 19: 
			return process.processMessageRead(data);
            
		case 21: 
			return process.processMessageDelete(data);
            
		case 22: 
			return process.processSendWebKey(data);
            
		case 23: 
			return process.processGetAffiliateContacts(data);
            
		case 24:
			return process.processSendAffiliateContactByUID(data);
            
		case 25:
			return process.processSendAffiliateContactByPN(data);
            
		case 26:
			return process.processGetUIDByPN(data);
            
		case 27:
			return process.processDeleteByMessageId(data);
            
		case 28:
			return process.processMessageDeleteResponse(data);
            
		case 29:
			return process.processMessageDeleteClose(data);
            
		case 30:
			return process.processRetentionPeriod(data);
            
		case 31:
			return process.processSubscription(data);
            
		case 32:
			return process.processLoginCreation(data);
            
		case 33:
			return process.processRestoreSubscription(data);
            
		case 34:
			return process.processResetPasswd(data);
            
		case 35:
			return process.processResetVerify(data);
            
		case 36:
			return process.processChangePasswd(data);
            
		default : 
			return process.doNothing();
          
		}
	}
}
