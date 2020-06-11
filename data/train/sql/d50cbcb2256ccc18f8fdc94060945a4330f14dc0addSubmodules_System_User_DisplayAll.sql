CALL moduleAddNewByPath(
	"Multiselection", 1, 1,
	"administrator/headmod_System/modules/mod_User/DisplayAll/Multiselection/Multiselection.php",
	"DisplayAll", "root/administrator/System/User/DisplayAll",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"ActionsGet", 1, 1,
	"administrator/headmod_System/modules/mod_User/DisplayAll/Multiselection/ActionsGet.php",
	"Multiselection", "root/administrator/System/User/DisplayAll/Multiselection",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"ActionExecute", 1, 1,
	"administrator/headmod_System/modules/mod_User/DisplayAll/Multiselection/ActionExecute.php",
	"Multiselection", "root/administrator/System/User/DisplayAll/Multiselection",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);