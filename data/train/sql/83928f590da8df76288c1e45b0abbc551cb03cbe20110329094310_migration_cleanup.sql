--// migration cleanup
-- Migration SQL that makes the change goes here.

alter table members.members 
add identity varchar(255) null;

alter table community.modulesettings add displayMembers varchar(55);
delete  from community.modulepage where page in (select contentType from contentstore.contenttype);

truncate community.modules;
LOCK TABLES community.`modules` WRITE;
/*!40000 ALTER TABLE community.`modules` DISABLE KEYS */;
INSERT INTO community.`modules` VALUES (3,'HTML','any','dsp_html','          ','widget','Add your own custom HTML','html_add.png','','frm_editHTML'),(4,'RSS','any','dsp_rss','          ','widget','Add your favorite RSS feed','rss_go.png','','frm_editRss'),(6,'Blogs','Home','content','blog','media','Publish content and allow members to comment','book.png','','frm_editContent'),(7,'Articles','Home','content','article','media','Publish content and allow members to comment','book.png','','frm_editContent'),(8,'Members','Home','dsp_memberList',NULL,'community','Show a list of your members','group.png','','frm_editGeneric'),(11,'Photo Galleries','Home','content','gallery','media','Add photos to your page','picture.png','','frm_editContent'),(15,'Weather','Home','dsp_weather',NULL,'widget','Add local weather forecast','weather_cloudy','','frm_editGeneric'),(16,'Horoscope','Home','dsp_horoscope',NULL,'widget','Add astrological horoscope ','star.png','','frm_editGeneric'),(17,'Forums','Home','dsp_forums',NULL,'community','Add community discussion forum','comments.png','','frm_editGeneric'),(18,'Bulletin','Home','dsp_bulletin',NULL,'community','Allow visitors to post notes','script_edit.png','','frm_editGeneric'),(19,'Poll','Home','dsp_poll',NULL,'promote','Ask your visitors a question and poll the results','chart_bar.png','','frm_editPoll'),(20,'Video','Home','content','video     ','media','Add videos to your page','webcam.png','','frm_editContent'),(24,'Mailing List','Home','dsp_mailinglist',NULL,'promote','Collect email addresses for marketing','email_edit.png','','frm_editGeneric'),(26,'Share','Home','dsp_share',NULL,'promote','Allow users to share page with others','thumb_up.png','','frm_editGeneric'),(27,'Invite','Home','dsp_invite',NULL,'promote','Allow members to invite others','group_go.png','','frm_editGeneric'),(28,'Music','Home','content','Music','media','Add music','cd.png','','frm_editContent'),(29,'Events','any','content','Event','community','Add events to your page','calendar.png','','frm_editContent'),(30,'Form','any','dsp_form',NULL,'widget','Create and manage your own forms','pencil.png','','frm_editTitle'),(31,'Knowledgebase','any','content','kb_topic','community','Create and manage help topics','help.png','','frm_editContent'),(32,'Mini Cart','any','dsp_shoppingMiniCart',NULL,'shopping','Display a mini shopping car','cart.png','','frm_editContent'),(33,'Categories','any','dsp_shoppingCategories',NULL,'shopping','Display the product categories','cart_go.png','','frm_editContent'),(34,'Photos','any','dsp_gallery','photo','media','Display a particular photo gallery','picture.png','','frm_editGallery'),(35,'Friends','any','dsp_friendList',NULL,'profile','Display a list of your friends','group.png','','frm_editGeneric'),(36,'Events','any','dsp_events','Event','profile','Display a list of events you posted','calendar.png','','frm_editEvent'),(37,'Comments','Profile','dsp_comments',NULL,'profile','Display comments from your friends','comments.png','','frm_editGeneric'),(38,'Login','any','dsp_login',NULL,'community','Display a Login Box','user.png','','frm_editTitle'),(39,'Advertisement','any','dsp_ad',NULL,'advertising','Display an ad unit','coin.png','','frm_ad'),(40,'Links','any','content','Link','community','Display a list of Links','link.png','','frm_editLinks'),(41,'Quote of the Day','any','dsp_quote',NULL,'widget','Display random quotes','comment.png','','frm_editTitle'),(42,'Word of the Day','any','dsp_word',NULL,'widget','Display a word of the day','book.png','',NULL),(43,'Twitter','any','dsp_twitter',NULL,'widget','Display a feed from a Twitter User or Keyword','twitter.png','','frm_editTwitter'),(44,'Property Listing','any','content','Property','media','Display a list of properties for sale','coins.png','','frm_editContent'),(45,'Documents','any','content','Document','media','Display a list of uploaded documents','folder.png','','frm_editContent'),(46,'Search','any','dsp_search','','media','Displays a search box','magnifier.png','','frm_editGeneric'),(47,'Recent Activity','any','dsp_recentActivity',NULL,'community','Displays a recent activity feed','script.png','','frm_editGeneric'),(48,'Groups','any','dsp_groups','Group','community','Display a listing of groups','users.png','','frm_editContent'),(49,'User Menu','any','dsp_userMenu','','community','User oriented profile menu','user.png','','frm_editGeneric'),(50,'DJ Charts','any','content','DJChart','media','Top 10 Music Chart','cd.png',NULL,'frm_editGeneric'),(51,'Map','any','dsp_map','','widget','Add a google maps interface','map.png','','frm_editMap'),(53,'Restaurants','any','content','restaurant','media','Add a restaurant listing','menu.png','','frm_editContent'),(54,'Location','any','content','location','media','Add a location / venue listing','building.png','','frm_editContent'),(59,'Restaurants','any','content','restaurant','media','Add a restaurant listing','menu.png','','frm_editContent'),(60,'Location','any','content','location','media','Add a location / venue listing','building.png','','frm_editContent'),(61,'Sites In My Network','any','dsp_sites',NULL,'community','Display other related sites in the network','group_link.png','','frm_editGeneric'),(62,'Job Postings','any','content','job','media','Add a Job listing','user.png','','frm_editContent'),(64,'Archives','any','nav_archives',NULL,'content','Archives by Year / Month','calendar.png','','frm_editGeneric'),(65,'Categories','any','nav_categories',NULL,'content','Categories',NULL,'','frm_editGeneric'),(66,'Embed','any','nav_embed',NULL,'content','Embed Code',NULL,'','frm_editGeneric'),(67,'Location Search','any','nav_locationSearch',NULL,'content','Search by Location',NULL,'','frm_editGeneric'),(68,'Map','any','nav_map',NULL,'content','Google Map','map.png','','frm_editGeneric'),(69,'Details','any','nav_mediaDetails',NULL,'content','Media Details ',NULL,'','frm_editGeneric'),(70,'Members','group','nav_members',NULL,'content','Group Members',NULL,'','frm_editGeneric'),(71,'RSVP','event','nav_rsvp',NULL,'content','RSVP to an Event',NULL,'','frm_editGeneric'),(72,'Share','any','nav_share',NULL,'content','Share',NULL,'','frm_editGeneric'),(73,'Tags','any','nav_tagcloud',NULL,'content','Tag Cloud',NULL,'','frm_editGeneric');
/*!40000 ALTER TABLE community.`modules` ENABLE KEYS */;
UNLOCK TABLES;

ALTER TABLE `statistics`.`files` DROP COLUMN `formname` ;
UPDATE `community`.`community` SET `subdomain`='mmj' WHERE `communityID`='251';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='1';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='2';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='4';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='5';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='7';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='30';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='35';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='38';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='90';

DELETE FROM `community`.`communitysettinglist` WHERE `settingID`='91';

insert into community.communitysettinglist
(name, valuelist, defaultvalue, settingType, sortOrder, description)

values
( 'facebookAPI', NULL, NULL, 'Site', '4', 'Facebook APIKey'),
( 'friends', 'On,Off', '1', 'general', '6', NULL);

insert into community.communitysettinglist
(name, valuelist, defaultvalue, settingType, sortOrder, description)

values
( 'linkedinlogin', NULL, 0, 'Site', '4', 'Allow Linked-In Login');



insert into community.communitysettinglist
(name, valuelist, defaultvalue, settingType, sortOrder, description)

values
( 'linkedinapi', NULL, 0, 'Site', '4', 'Linked-In API Key');

insert into community.communitysettinglist
(name, valuelist, defaultvalue, settingType, sortOrder, description)

values
( 'linkedinsecret', NULL, 0, 'Site', '4', 'ALinked-In API Secret');

delete from community.pageSettingList where page not in ('any', 'content');


alter table community.modules
add defaultTemplate varchar(55);

alter table community.modulesettings
add operator varchar(5) default '>';
--//@UNDO
-- SQL to undo the change goes here.



