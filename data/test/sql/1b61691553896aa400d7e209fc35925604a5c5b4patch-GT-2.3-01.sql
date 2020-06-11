# 09 Aug 2004   [Mahesh] Add ARCHIVE_ALERT,RESTORE_ALERT alert



USE userdb;

INSERT INTO message_template (UID, Name, ContentType, MessageType, FromAddr, ToAddr, CcAddr, Subject, Message, Location, Append, Version, CanDelete) VALUES (-23,'GTAS ARCHIVE ALERT','Text','EMail','<#USER=admin#>','<#USER=admin#>',NULL,'Archive Complete','Dear User,\r\nArchival Status: <%ARCHIVE.STATUS%>.\r\nArchival is completed\r\nArchival Summary file is attached to this mail.\r\nLook into the summary file for details.\r\nGridTalk Server.\r\n',NULL,0,1,0);
INSERT INTO alert (UID, Name, AlertType, Category, Trigger, Description, Version, CanDelete) VALUES (-17,'ARCHIVE_ALERT',17,NULL,NULL,'ARCHIVE_ALERT',1,0);
INSERT INTO action (UID, Name, Description, MsgUid, Version, CanDelete) VALUES (-23,'ARCHIVE_ALERT_ACTION','Archive Alert Action',-23,1,0);
INSERT INTO alert_action (UID, AlertUid, ActionUid) VALUES (-24,-17,-23);

INSERT INTO message_template (UID, Name, ContentType, MessageType, FromAddr, ToAddr, CcAddr, Subject, Message, Location, Append, Version, CanDelete) VALUES (-24,'GTAS RESTORE ALERT','Text','EMail','<#USER=admin#>','<#USER=admin#>',NULL,'Restore Complete','Dear User,\r\nRestore Status: <%ARCHIVE.STATUS%>.\r\nRestore is completed\r\nArchival Summary file is attached to this mail.\r\nGridTalk Server.\r\n',NULL,0,1,0);
INSERT INTO alert (UID, Name, AlertType, Category, Trigger, Description, Version, CanDelete) VALUES (-18,'RESTORE_ALERT',17,NULL,NULL,'RESTORE_ALERT',1,0);
INSERT INTO action (UID, Name, Description, MsgUid, Version, CanDelete) VALUES (-24,'RESTORE_ALERT_ACTION','Restore Alert Action',-24,1,0);
INSERT INTO alert_action (UID, AlertUid, ActionUid) VALUES (-25,-18,-24);