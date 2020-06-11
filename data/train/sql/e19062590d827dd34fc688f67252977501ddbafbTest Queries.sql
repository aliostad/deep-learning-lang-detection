select * from MigrationStats;
select * from ListTypes;
select * from Members;
select * from MemberGroups;
select * from Teams;
select * from Schedules;
select * from Projects;
select * from Programs;
select * from Iterations;
select * from Goals;
select * from FeatureGroups;
select * from Requests;
select * from Issues;
select * from Epics;
select * from Stories;
select * from Defects;
select * from Tasks;
select * from Tests;
select * from Links;
select * from Conversations;
select * from Actuals;
select * from Attachments;
select * from CustomFields;

select COUNT(*) as 'Total Stories' from Stories
select COUNT(*) as 'Total Active' from Stories where AssetState = 'Active'
select COUNT(*) as 'Total Closed' from Stories where AssetState = 'Closed'
select COUNT(*) as 'Total Templates' from Stories where AssetState = 'Template'
select COUNT(*) as 'Total Epic/Stories' from Epics


select COUNT(*) from Actuals
where NewAssetOID is null

select * from Members where Username like '%\%'

select * from CustomFields where AssetOID in (select AssetOID from Tests);
select * from CustomFields where FieldName like 'Custom_ReleaseDate%';
select * from CustomFields where AssetOID like 'Test%';

-- http://localhost/versionone/rest-1.v1/Data/Request?sel=Name&where=Scope.ParentMeAndUp='Scope:1310';AssetState!='Dead'

-- Get the root project.
select * from Projects where Parent not in (select AssetOID from Projects) 


-- Set all NewAssetOIDs to NULL
TRUNCATE TABLE MigrationStats;
update ListTypes set NewAssetOID = null, NewEpicAssetOID = null;
update Members set NewAssetOID = null;
update MemberGroups set NewAssetOID = null;
update Teams set NewAssetOID = null;
update Schedules set NewAssetOID = null;
update Projects set NewAssetOID = null;
update Programs set NewAssetOID = null;
update Iterations set NewAssetOID = null;
update Goals set NewAssetOID = null, NewAssetNumber = null;
update FeatureGroups set NewAssetOID = null, NewAssetNumber = null;
update Requests set NewAssetOID = null, NewAssetNumber = null;
update Issues set NewAssetOID = null, NewAssetNumber = null;
update Epics set NewAssetOID = null, NewAssetNumber = null;
update Stories set NewAssetOID = null, NewAssetNumber = null;
update Defects set NewAssetOID = null, NewAssetNumber = null;
update Tasks set NewAssetOID = null, NewAssetNumber = null;
update Tests set NewAssetOID = null, NewAssetNumber = null;
update Links set NewAssetOID = null;
update Conversations set NewAssetOID = null;
update Actuals set NewAssetOID = null;
update Attachments set NewAssetOID = null;




SELECT * FROM Stories WITH (NOLOCK) WHERE AssetState = 'Closed' AND NewAssetOID <> 'FAILED' ORDER BY AssetOID DESC;

select * from Projects where AssetState = 'Closed'

select * from Epics where SCOPE in (select AssetOID from Projects where AssetState = 'Closed')

select NewAssetNumber from Stories
where AssetOID in (select BaseAssets from Conversations)

select * from Conversations
where BaseAssets in (select AssetOID from Stories)

select * from Epics

select * from CustomFields
where AssetOID in (select AssetOID from Epics)
and FieldName = 'Custom_ReleaseComments'


select a.AssetOID, b.NewAssetOID, b.NewAssetNumber,a.FieldName, a.FieldType, a.FieldValue from CustomFields as a
inner join Epics as b
on a.AssetOID = b.AssetOID
where a.FieldName = 'Custom_KanbanStatus2'
and b.NewAssetOID <> 'FAILED'

select * from Epics where AssetOID = 'Story:2666926'

SELECT a.AssetOID, b.NewAssetOID, b.NewAssetNumber, a.FieldName, a.FieldType, a.FieldValue FROM CustomFields AS a 
INNER JOIN Epics AS b ON a.AssetOID = b.AssetOID 
WHERE a.FieldName = 'Custom_Stakeholders' AND b.NewAssetOID <> 'FAILED';



