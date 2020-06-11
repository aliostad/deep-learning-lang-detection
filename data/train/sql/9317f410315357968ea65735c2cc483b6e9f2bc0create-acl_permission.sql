CREATE TABLE `acl_permission` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `RoleID` int(11) DEFAULT NULL,
  `ResourceID` int(11) DEFAULT NULL,
  `Privileges` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ResourceID` (`ResourceID`),
  KEY `acl_permission_ibfk_1` (`RoleID`),
  CONSTRAINT `acl_permission_ibfk_1` FOREIGN KEY (`RoleID`) REFERENCES `acl_role` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `acl_permission_ibfk_2` FOREIGN KEY (`ResourceID`) REFERENCES `acl_resource` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE
)  AUTO_INCREMENT=227 DEFAULT CHARSET=latin1;




insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (177,3,5,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (189,3,8,'a:3:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (190,3,1,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (191,3,2,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (194,3,6,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (195,3,12,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (196,3,3,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (197,3,4,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (198,3,7,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (199,3,10,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (200,3,11,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (201,1,8,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (202,1,1,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (203,1,15,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (204,1,5,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (205,1,2,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (206,1,13,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (207,1,14,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (208,1,6,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (209,1,12,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (210,1,3,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (211,1,4,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (212,1,7,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (213,1,10,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (214,1,11,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (215,3,15,'a:4:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";i:3;s:6:"Delete";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (216,7,8,'a:2:{i:0;s:4:"Read";i:1;s:6:"Update";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (217,7,1,'a:2:{i:0;s:4:"Read";i:1;s:6:"Update";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (218,7,15,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (219,7,2,'a:3:{i:0;s:4:"Read";i:1;s:6:"Update";i:2;s:6:"Create";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (220,7,6,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (221,7,12,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (222,7,3,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (223,7,4,'a:2:{i:0;s:4:"Read";i:1;s:6:"Update";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (224,7,7,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (225,7,11,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (226,1,16,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (227,13,8,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (228,13,1,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (229,13,15,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (230,13,16,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (233,13,13,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (234,13,14,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (235,13,6,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (236,13,12,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (240,13,10,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (241,13,11,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (242,20,8,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (243,20,1,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (244,20,15,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (245,20,14,'a:1:{i:0;s:4:"Read";}');
insert into `acl_permission`(`ID`,`RoleID`,`ResourceID`,`Privileges`) values (246,20,11,'a:1:{i:0;s:4:"Read";}');
