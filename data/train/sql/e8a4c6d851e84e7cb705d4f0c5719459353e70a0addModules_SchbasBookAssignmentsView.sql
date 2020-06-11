CALL moduleAddNewByPath(
	"Add", 1, 0,
	"administrator/Schbas/BookAssignments/View/Add/Add.php",
	"View", "root/administrator/Schbas/BookAssignments/View",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Delete", 1, 0,
	"administrator/Schbas/BookAssignments/View/Delete/Delete.php",
	"View", "root/administrator/Schbas/BookAssignments/View",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Users", 1, 0,
	"administrator/Schbas/BookAssignments/View/Users/Users.php",
	"View", "root/administrator/Schbas/BookAssignments/View",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);