-- Set all NewAssetOIDs to NULL
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


