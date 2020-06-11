CALL moduleAddNewByPath(
	"Dashboard", 1, 1,
	"administrator/Schbas/Dashboard/Dashboard.php",
	"Schbas", "root/administrator/Schbas",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Preparation", 1, 0,
	"administrator/Schbas/Dashboard/Preparation/Preparation.php",
	"Dashboard", "root/administrator/Schbas/Dashboard",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"AssignmentsController", 1, 0,
	"administrator/Schbas/Dashboard/Preparation/AssignmentsController.php",
	"Preparation", "root/administrator/Schbas/Dashboard/Preparation",
	@newModuleId
);

INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);
	CALL moduleAddNewByPath(
	"ClaimForm", 1, 0,
	"administrator/Schbas/Dashboard/Preparation/ClaimForm.php",
	"Preparation", "root/administrator/Schbas/Dashboard/Preparation",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Deadlines", 1, 0,
	"administrator/Schbas/Dashboard/Preparation/Deadlines.php",
	"Preparation", "root/administrator/Schbas/Dashboard/Preparation",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"SchbasClaimStatus", 1, 0,
	"administrator/Schbas/Dashboard/Preparation/SchbasClaimStatus.php",
	"Preparation", "root/administrator/Schbas/Dashboard/Preparation",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

CALL moduleAddNewByPath(
	"Schoolyear", 1, 0,
	"administrator/Schbas/Dashboard/Preparation/Schoolyear.php",
	"Preparation", "root/administrator/Schbas/Dashboard/Preparation",
	@newModuleId
);
INSERT INTO SystemGroupModuleRights (groupId, moduleId)
	VALUES (3, @newModuleId);

