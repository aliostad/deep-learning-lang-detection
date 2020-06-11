insert into `secObjectName` (`objectName`) values ('_newCasemgmt.socialHistory');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.ongoingConcerns');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.reminders');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.resolvedIssues');
insert into `secObjectName` (`objectName`) values ('_newCasemgmt.unresolvedIssues');

insert into `secObjPrivilege` values('admin','_newCasemgmt.socialHistory','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.ongoingConcerns','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.reminders','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.resolvedIssues','x',0,'999998');
insert into `secObjPrivilege` values('admin','_newCasemgmt.unresolvedIssues','x',0,'999998');

insert into `secObjPrivilege` values('doctor','_newCasemgmt.socialHistory','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.ongoingConcerns','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.reminders','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.resolvedIssues','x',0,'999998');
insert into `secObjPrivilege` values('doctor','_newCasemgmt.unresolvedIssues','x',0,'999998');

insert into `secObjPrivilege` values('nurse','_newCasemgmt.socialHistory','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_newCasemgmt.ongoingConcerns','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_newCasemgmt.reminders','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_newCasemgmt.resolvedIssues','x',0,'999998');
insert into `secObjPrivilege` values('nurse','_newCasemgmt.unresolvedIssues','x',0,'999998');

update program set programStatus='active' where programStatus is null; 
