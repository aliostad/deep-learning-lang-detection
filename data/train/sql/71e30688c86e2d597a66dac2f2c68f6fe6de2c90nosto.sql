CREATE TABLE `xplugin_agws_nosto_track_accounts` (
  `cAccountID` VARCHAR(255),
  `kSprache` INT UNSIGNED NOT NULL
) ENGINE = MYISAM DEFAULT CHARSET = latin1;

INSERT INTO xplugin_agws_nosto_track_recommendations ( iNostoRecommendationsSlotID ,iSideID ,cCSSSelektor ,cPQueryMethode ,cRecommendationsSlotID ,bActivate )
        SELECT 100,  1, '#content',          'append', 'productpage-nosto-3',     1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations)
 UNION (SELECT 101,  1, '#content',          'append', 'productpage-nosto-2',     1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 102,  2, '.category_wrapper', 'after',  'productcategory-nosto-1', 1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 103,  1, '#content',          'append', 'productpage-nosto-3',     1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 104,  1, '#content',          'append', 'productpage-nosto-2',     1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 105,  2, '.category_wrapper', 'after',  'productcategory-nosto-1', 1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 106,  2, '#content',          'append', 'productcategory-nosto-2', 1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 107,  2, '#improve_search',   'before', 'searchpage-nosto-1',      1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 108,  3, '#content',          'append', 'cartpage-nosto-1',        1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 109,  3, '#content',          'append', 'cartpage-nosto-2',        1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 110,  3, '#content',          'append', 'cartpage-nosto-3',        1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 111, 18, '#content',          'append', 'frontpage-nosto-3',       1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 112, 18, '#content',          'append', 'frontpage-nosto-4',       1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 113, 18, '#content',          'append', 'frontpage-nosto-2',       1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations))
 UNION (SELECT 114, 18, '#content',          'append', 'frontpage-nosto-1',       1 FROM dual WHERE NOT EXISTS (SELECT * FROM xplugin_agws_nosto_track_recommendations));