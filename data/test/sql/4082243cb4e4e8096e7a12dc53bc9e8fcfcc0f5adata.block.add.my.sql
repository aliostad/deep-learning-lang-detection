# Setup blocks for publisher

INSERT INTO `block` VALUES ({SGL_NEXT_ID}, 'Navigation_Block_CategoryNav', 'Categories', '', 'navWidget', 1, 'AdminCategory', 1, 1, 'N;');

-- get the block ID for the navigation block, 'adminCategoryNav'
SELECT @catBlockId := block_id FROM block WHERE name = 'Navigation_Block_CategoryNav';

-- get IDs for relevant publisher sections: Publishing/Articles/Categories/Files
SELECT @sectionIdPublishing := section_id FROM section WHERE title = 'Publishing';
SELECT @sectionIdArticles := section_id FROM section WHERE title = 'Articles';
SELECT @sectionIdCategories := section_id FROM section WHERE title = 'Categories';
SELECT @sectionIdFiles := section_id FROM section WHERE title = 'Files';

-- create block assignments
INSERT INTO `block_assignment` VALUES (@catBlockId, @sectionIdPublishing);
INSERT INTO `block_assignment` VALUES (@catBlockId, @sectionIdArticles);
INSERT INTO `block_assignment` VALUES (@catBlockId, @sectionIdCategories);
INSERT INTO `block_assignment` VALUES (@catBlockId, @sectionIdFiles);

-- create block role assignments
INSERT INTO `block_role` VALUES (@catBlockId, 1);

-- sample blocks
INSERT INTO `block` VALUES ({SGL_NEXT_ID}, 'Publisher_Block_SiteNews', 'Site News', '', '', 4, 'Left', 0, 1, 'N;');
INSERT INTO `block` VALUES ({SGL_NEXT_ID}, 'Publisher_Block_RecentHtmlArticles2', 'Recent articles', '', '', 3, 'Right', 0, 1, 'N;');
INSERT INTO `block` VALUES ({SGL_NEXT_ID}, 'Publisher_Block_Html', 'Seagull Gear', '', '', 6, 'Right', 1, 0, 'a:1:{s:4:"html";s:219:"<a href="http://www.cafepress.com/seagullsystems" title="Buy Seagull Gear"><img src="http://seagullfiles.phpkitchen.com/images/seagull_gear.png" alt="Buy Seagull gear and support the project" title="Seagull Gear" /></a>";}');
INSERT INTO `block` VALUES ({SGL_NEXT_ID}, 'Publisher_Block_Html', 'Donate', '', '', 1, 'Left', 1, 0, 'a:1:{s:4:"html";s:252:"<div class="alignCenter">\r\n<a href="http://sf.net/donate/index.php?group_id=92482"><img src="http://seagullfiles.phpkitchen.com/images/project-support.jpg" border="0" alt="Support The Seagull PHP Framework Project" width="88" height="32" /></a>\r\n</div>";}');

SELECT @blockIdSiteNews := block_id FROM block WHERE name = 'Publisher_Block_SiteNews';
SELECT @blockIdRecentHtmlArticles2 := block_id FROM block WHERE name = 'Publisher_Block_RecentHtmlArticles2';
SELECT @blockIdSeagullGear := block_id FROM block WHERE title = 'Seagull Gear';
SELECT @blockIdDonate := block_id FROM block WHERE title = 'Donate';

INSERT INTO `block_assignment` VALUES (@blockIdSiteNews, 0);
INSERT INTO `block_assignment` VALUES (@blockIdRecentHtmlArticles2, 0);
INSERT INTO `block_assignment` VALUES (@blockIdSeagullGear, 0);
INSERT INTO `block_assignment` VALUES (@blockIdDonate, 0);

INSERT INTO `block_role` VALUES (@blockIdSiteNews, -2);
INSERT INTO `block_role` VALUES (@blockIdRecentHtmlArticles2, -2);
INSERT INTO `block_role` VALUES (@blockIdSeagullGear, -2);
INSERT INTO `block_role` VALUES (@blockIdDonate, -2);