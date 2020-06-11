CALL moduleAddNewByPath(
	"ShowBooklist", 1, 1,
	"administrator/headmod_Schbas/modules/mod_Booklist/ShowBooklist.php",
	"Booklist", "root/administrator/Schbas/Booklist",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"EditBook", 1, 1,
	"administrator/headmod_Schbas/modules/mod_Booklist/EditBook.php",
	"Booklist", "root/administrator/Schbas/Booklist",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"DeleteBook", 1, 1,
	"administrator/headmod_Schbas/modules/mod_Booklist/DeleteBook.php",
	"Booklist", "root/administrator/Schbas/Booklist",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"CreateBook", 1, 1,
	"administrator/headmod_Schbas/modules/mod_Booklist/CreateBook.php",
	"Booklist", "root/administrator/Schbas/Booklist",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);