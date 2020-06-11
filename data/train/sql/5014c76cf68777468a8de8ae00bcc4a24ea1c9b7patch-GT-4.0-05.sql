# 06 Apr 2006     [Tam Wei Xiang]       1) Add in new alert DOCUMENT_RESEND_EXHAUSTED
#                                       2) Modfied template "DOCUMENT_RECEIVED_BY_PARTNER_EMAIL" 

USE userdb;



#Alert TYPE
DELETE FROM alert_type WHERE Name='DOCUMENT_RESEND_EXHAUSTED';
INSERT INTO alert_type (UID, Name, Description, Version, CanDelete) VALUES (21,'DOCUMENT_RESEND_EXHAUSTED','Document Resend Exhausted',1,0);

#Msg-Template
DELETE FROM message_template WHERE NAME='DOCUMENT_RECEIVED_BY_PARTNER_EMAIL';
INSERT INTO message_template (UID, Name, ContentType, MessageType, FromAddr, ToAddr, CcAddr, Subject, Message, Location, Append, Version, CanDelete) VALUES (-10,'DOCUMENT_RECEIVED_BY_PARTNER_EMAIL','Text','EMail','<#USER=admin#>','<#USER=admin#>',NULL,'Document <%GridDocument.U_DOC_FILENAME%> has been received by Partner <%GridDocument.R_PARTNER_ID%>','Document <%GridDocument.U_DOC_FILENAME%> has been received by Partner <%GridDocument.R_PARTNER_ID%> on <%GridDocument.DT_TRANSACTION_COMPLETE%>.\r\n\r\nDocument Details:\r\n-----------------\r\nDocument Type    : <%GridDocument.U_DOC_DOC_TYPE%>\r\nFile Type        : <%GridDocument.U_DOC_FILE_TYPE%>\r\nGridDoc ID       : <%GridDocument.G_DOC_ID%>\r\nPartner Name     : <%GridDocument.R_PARTNER_NAME%>\r\nChannel          : <%GridDocument.R_CHANNEL_NAME%>\r\nRoute            : <%GridDocument.ROUTE%>\r\nRecpt GridDoc ID : <%GridDocument.R_G_DOC_ID%>\r\nDoc Trans Status : <%GridDocument.DOC_TRANS_STATUS%>',NULL,0,1,0);

DELETE FROM message_template WHERE NAME='DOCUMENT_RESEND_EXHAUSTED';
INSERT INTO message_template (UID, Name, ContentType, MessageType, FromAddr, ToAddr, CcAddr, Subject, Message, Location, Append, Version, CanDelete) VALUES (-29,'DOCUMENT_RESEND_EXHAUSTED','Text','EMail','<#USER=admin#>','<#USER=admin#>','','Document <%GridDocument.U_DOC_FILENAME%> resend count has exhausted','Document <%GridDocument.U_DOC_FILENAME%> has reached its maximum resend.\r\n\r\nDocument Details:\r\n-----------------\r\nDocument Type      : <%GridDocument.U_DOC_DOC_TYPE%>\r\nFile Type          : <%GridDocument.U_DOC_FILE_TYPE%>\r\nGridDoc ID         : <%GridDocument.G_DOC_ID%>\r\nFolder             : <%GridDocument.FOLDER%>\r\nPartner Name       : <%GridDocument.R_PARTNER_NAME%>\r\nChannel            : <%GridDocument.R_CHANNEL_NAME%>',NULL,NULL,1,0);

#Alert
DELETE FROM alert WHERE UID=-22;
INSERT INTO alert (UID, Name, AlertType, Category, TriggerCond, Description, Version, CanDelete) VALUES (-22,'DOCUMENT_RESEND_EXHAUSTED',21,NULL,NULL,'Default Document Resend Exhausted Alert',1,0);

#Action
DELETE FROM action WHERE UID=-29;
INSERT INTO action (UID, Name, Description, MsgUid, Version, CanDelete) VALUES (-29,'DOCUMENT_RESEND_EXHAUSTED_EMAIL','Document Resend Exhausted Email Action',-29,1,0);

#Alert-Action
DELETE FROM alert_action WHERE UID=-30;
INSERT INTO alert_action (UID, AlertUid, ActionUid) VALUES(-30,-22,-29);

#Alert Trigger
DELETE FROM alert_trigger WHERE UID=-18;
INSERT INTO alert_trigger (UID, Level, AlertType, AlertUID, DocType, PartnerType, PartnerGroup, PartnerId, Recipients, Enabled, AttachDoc, CanDelete, Version) VALUES (-18,0,'DOCUMENT_RESEND_EXHAUSTED',-22,NULL,NULL,NULL,NULL,NULL,1,0,0,1);