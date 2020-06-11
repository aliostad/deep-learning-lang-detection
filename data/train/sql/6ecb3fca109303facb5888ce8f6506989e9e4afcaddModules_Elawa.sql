-- administrator
CALL moduleAddNewByPath(
	"Elawa", 1, 1,
	"administrator/Elawa/Elawa.php",
	"administrator", "root/administrator",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"MainMenu", 1, 1,
	"administrator/Elawa/MainMenu.php",
	"Elawa", "root/administrator/Elawa",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"GenerateHostPdf", 1, 1,
	"administrator/Elawa/GenerateHostPdf/GenerateHostPdf.php",
	"Elawa", "root/administrator/Elawa",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"SetHostGroup", 1, 1,
	"administrator/Elawa/SetHostGroup/SetHostGroup.php",
	"Elawa", "root/administrator/Elawa",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"SetSelectionsEnabled", 1, 1,
	"administrator/Elawa/SetSelectionsEnabled/SetSelectionsEnabled.php",
	"Elawa", "root/administrator/Elawa",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Meetings", 1, 1,
	"administrator/Elawa/Meetings/Meetings.php",
	"Elawa", "root/administrator/Elawa",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"GenerateBare", 1, 1,
	"administrator/Elawa/Meetings/GenerateBare/GenerateBare.php",
	"Meetings", "root/administrator/Elawa/Meetings",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"ChangeDisableds", 1, 1,
	"administrator/Elawa/Meetings/ChangeDisableds/ChangeDisableds.php",
	"Meetings", "root/administrator/Elawa/Meetings",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Defaults", 1, 1,
	"administrator/Elawa/Meetings/Defaults/Defaults.php",
	"Meetings", "root/administrator/Elawa/Meetings",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Times", 1, 1,
	"administrator/Elawa/Meetings/Defaults/Times/Times.php",
	"Defaults", "root/administrator/Elawa/Meetings/Defaults",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Rooms", 1, 1,
	"administrator/Elawa/Meetings/Defaults/Rooms/Rooms.php",
	"Defaults", "root/administrator/Elawa/Meetings/Defaults",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);


-- web

CALL moduleAddNewByPath(
	"Elawa", 1, 1,
	"web/Elawa/Elawa.php",
	"web", "root/web",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Overview", 1, 1,
	"web/Elawa/Overview/Overview.php",
	"Elawa", "root/web/Elawa",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);


CALL moduleAddNewByPath(
	"Selection", 1, 1,
	"web/Elawa/Selection/Selection.php",
	"Elawa", "root/web/Elawa",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);


CALL moduleAddNewByPath(
	"GeneratePdf", 1, 1,
	"web/Elawa/GeneratePdf/GeneratePdf.php",
	"Elawa", "root/web/Elawa",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);