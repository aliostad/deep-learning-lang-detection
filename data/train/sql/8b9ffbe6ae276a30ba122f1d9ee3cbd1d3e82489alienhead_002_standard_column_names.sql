## Rename some column names to use underscores

## Table: categories
ALTER TABLE  `categories` CHANGE  `isHub`  `is_hub` TINYINT( 1 ) NOT NULL DEFAULT  '0',
CHANGE  `returnAllContent`  `return_all_content` INT( 1 ) NOT NULL DEFAULT  '0',
CHANGE  `allowZIP`  `allow_ZIP` INT( 1 ) NOT NULL DEFAULT  '0',
CHANGE  `oldestFirst`  `oldest_first` INT( 1 ) NOT NULL DEFAULT  '0',
CHANGE  `allowPlayAll`  `allow_play_all` INT( 1 ) NOT NULL ,
CHANGE  `navComic`  `nav_comic` INT( 1 ) NOT NULL ,
CHANGE  `comicnav_first`  `nav_comic_first` INT( 11 ) NOT NULL ,
CHANGE  `comicnav_back`  `nav_comic_back` INT( 11 ) NOT NULL ,
CHANGE  `comicnav_next`  `nav_comic_next` INT( 11 ) NOT NULL ,
CHANGE  `comicnav_last`  `nav_comic_last` INT( 11 ) NOT NULL ,
CHANGE  `listPriority`  `list_priority` INT( 11 ) NOT NULL DEFAULT  '0' COMMENT  'list priority level. higher numbers come first'

## Table: content
ALTER TABLE  `content` CHANGE  `customEmbed`  `custom_embed` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL

## Table: contentauthors
ALTER TABLE  `contentauthors` CHANGE  `showIcon`  `show_icon` INT( 1 ) NOT NULL DEFAULT  '1'

## Table: files
ALTER TABLE  `files` CHANGE  `isDownloadable`  `is_downloadable` INT( 11 ) NOT NULL DEFAULT  '0',
CHANGE  `internalDescription`  `internal_description` TINYTEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT  'Put in a description of the file to help keep track of what file this is.'