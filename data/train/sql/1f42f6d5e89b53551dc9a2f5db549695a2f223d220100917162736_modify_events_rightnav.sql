--// modify events rightnav
update contentstore.UISettings
set detailRightNav = 'MediaDetails,RSVP,Map,Share'
where contentType = 'event';

INSERT INTO `community`.`pageSettingList`
(`name`,`valuelist`,`defaultvalue`,`settingType`,`sortOrder`,`page`,`description`,`settingGroup`)
VALUES
('Map','0,1','1','bit',9,'event','Map','Modules');

--//@UNDO
update contentstore.UISettings
set detailRightNav = 'MediaDetails,Share,RSVP'
where contentType = 'event';

delete from `community`.`pageSettingList` 
where settinggroup = 'modules'
and page = 'event'
and name='map';