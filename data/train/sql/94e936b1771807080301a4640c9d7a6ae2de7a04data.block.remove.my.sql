-- get block IDs
SELECT @catBlockId := block_id FROM block WHERE name = 'Navigation_Block_CategoryNav';
SELECT @blockIdSiteNews := block_id FROM block WHERE name = 'Publisher_Block_SiteNews';
SELECT @blockIdRecentHtmlArticles2 := block_id FROM block WHERE name = 'Publisher_Block_RecentHtmlArticles2';
SELECT @blockIdSeagullGear := block_id FROM block WHERE title = 'Seagull Gear';
SELECT @blockIdDonate := block_id FROM block WHERE title = 'Donate';

DELETE FROM `block` WHERE block_id = @catNavBlockId;
DELETE FROM `block` WHERE block_id = @blockIdSiteNews;
DELETE FROM `block` WHERE block_id = @blockIdRecentHtmlArticles2;
DELETE FROM `block` WHERE block_id = @blockIdSeagullGear;
DELETE FROM `block` WHERE block_id = @blockIdDonate;

-- delete assignments
DELETE FROM `block_assignment` WHERE block_id = @catBlockId;
DELETE FROM `block_assignment` WHERE block_id = @blockIdSiteNews;
DELETE FROM `block_assignment` WHERE block_id = @blockIdRecentHtmlArticles2;
DELETE FROM `block_assignment` WHERE block_id = @blockIdSeagullGear;
DELETE FROM `block_assignment` WHERE block_id = @blockIdDonate;

-- delete role assignments
DELETE FROM `block_role` WHERE block_id = @catBlockId;
DELETE FROM `block_role` WHERE block_id = @blockIdSiteNews;
DELETE FROM `block_role` WHERE block_id = @blockIdRecentHtmlArticles2;
DELETE FROM `block_role` WHERE block_id = @blockIdSeagullGear;
DELETE FROM `block_role` WHERE block_id = @blockIdDonate;