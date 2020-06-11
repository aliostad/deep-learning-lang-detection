-- ///////////////////////////////////////////////////////////
-- // PROJECTOR                                             //
-- //-------------------------------------------------------//
-- // Version : 4.1.0                                       //
-- //           specific updates for flash report           //
-- // Date : 2013-11-14                                     //
-- ///////////////////////////////////////////////////////////
--
--

INSERT INTO `${prefix}report` (`id`, `name`, `idReportCategory`, `file`, `sortOrder`, `idle`) VALUES 
(51, 'flashReport', '9', 'projectFlashReport.php', '930', '0');

INSERT INTO `${prefix}reportparameter` (`idReport`, `name`, `paramType`, `sortOrder`, `idle`, `defaultValue`) VALUES
(51, 'idProject', 'projectList', 10, 0, 'currentProject');

INSERT INTO `${prefix}habilitationreport` (`idProfile`,`idReport`,`allowAccess`) VALUES
(1,51,1),
(2,51,1),
(3,51,1);