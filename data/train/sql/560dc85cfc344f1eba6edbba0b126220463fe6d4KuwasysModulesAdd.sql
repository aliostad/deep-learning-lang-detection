CALL moduleAddNewByPath("CsvImport", 1, 1, "administrator/headmod_Kuwasys/modules/mod_Classes/CsvImport/CsvImport.php", "Classes",
	"root/administrator/Kuwasys/Classes", @newId);
INSERT INTO `GroupModuleRights` (groupId, moduleId) VALUES
	(3, @newId);
CALL moduleAddNewByPath("FileUploadForm", 1, 1, "administrator/headmod_Kuwasys/modules/mod_Classes/CsvImport/FileUploadForm.php", "CsvImport",
	"root/administrator/Kuwasys/Classes/CsvImport", @newId);
INSERT INTO `GroupModuleRights` (groupId, moduleId) VALUES
	(3, @newId);
CALL moduleAddNewByPath("Review", 1, 1, "administrator/headmod_Kuwasys/modules/mod_Classes/CsvImport/Review.php", "CsvImport",
	"root/administrator/Kuwasys/Classes/CsvImport", @newId);
INSERT INTO `GroupModuleRights` (groupId, moduleId) VALUES
	(3, @newId);
CALL moduleAddNewByPath("ImportExecute", 1, 1, "administrator/headmod_Kuwasys/modules/mod_Classes/CsvImport/ImportExecute.php", "CsvImport",
	"root/administrator/Kuwasys/Classes/CsvImport", @newId);
INSERT INTO `GroupModuleRights` (groupId, moduleId) VALUES
	(3, @newId);

CALL moduleAddNewByPath("CsvImport", 1, 1, "administrator/headmod_Kuwasys/modules/mod_Classteachers/CsvImport/CsvImport.php", "Classteachers",
	"root/administrator/Kuwasys/Classteachers", @newId);
INSERT INTO `GroupModuleRights` (groupId, moduleId) VALUES
	(3, @newId);
CALL moduleAddNewByPath("FileUploadForm", 1, 1, "administrator/headmod_Kuwasys/modules/mod_Classteachers/CsvImport/FileUploadForm.php", "CsvImport",
	"root/administrator/Kuwasys/Classteachers/CsvImport", @newId);
INSERT INTO `GroupModuleRights` (groupId, moduleId) VALUES
	(3, @newId);
CALL moduleAddNewByPath("Review", 1, 1, "administrator/headmod_Kuwasys/modules/mod_Classteachers/CsvImport/Review.php", "CsvImport",
	"root/administrator/Kuwasys/Classteachers/CsvImport", @newId);
INSERT INTO `GroupModuleRights` (groupId, moduleId) VALUES
	(3, @newId);
CALL moduleAddNewByPath("ImportExecute", 1, 1, "administrator/headmod_Kuwasys/modules/mod_Classteachers/CsvImport/ImportExecute.php", "CsvImport",
	"root/administrator/Kuwasys/Classteachers/CsvImport", @newId);
INSERT INTO `GroupModuleRights` (groupId, moduleId) VALUES
	(3, @newId);
