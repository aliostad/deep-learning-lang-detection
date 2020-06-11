<?php

$config = '{"article_layout":"_:default","show_title":"1","link_titles":"1","show_intro":"1","show_category":"0","link_category":"0","show_parent_category":"0","link_parent_category":"0","show_author":"0","link_author":"0","show_create_date":"0","show_modify_date":"0","show_publish_date":"0","show_item_navigation":"0","show_vote":"0","show_readmore":"1","show_readmore_title":"0","readmore_limit":"100","show_icons":"0","show_print_icon":"0","show_email_icon":"0","show_hits":"0","show_noauth":"1","category_layout":"_:blog","show_category_title":"0","show_description":"0","show_description_image":"0","maxLevel":"0","show_empty_categories":"0","show_no_articles":"0","show_subcat_desc":"0","show_cat_num_articles":"0","show_base_description":"1","maxLevelcat":"-1","show_empty_categories_cat":"0","show_subcat_desc_cat":"1","show_cat_num_articles_cat":"0","num_leading_articles":"6","num_intro_articles":"0","num_columns":"1","num_links":"0","multi_column_order":"0","show_subcategory_content":"-1","show_pagination_limit":"1","filter_field":"hide","show_headings":"1","list_show_date":"0","date_format":"","list_show_hits":"1","list_show_author":"0","orderby_pri":"none","orderby_sec":"rdate","order_date":"published","show_pagination":"2","show_pagination_results":"1","show_feed_link":"1","feed_summary":"0","filters":{"1":{"filter_type":"BL","filter_tags":"","filter_attributes":""},"6":{"filter_type":"NONE","filter_tags":"","filter_attributes":""},"7":{"filter_type":"NONE","filter_tags":"","filter_attributes":""},"2":{"filter_type":"NONE","filter_tags":"","filter_attributes":""},"3":{"filter_type":"NONE","filter_tags":"","filter_attributes":""},"4":{"filter_type":"NONE","filter_tags":"","filter_attributes":""},"5":{"filter_type":"NONE","filter_tags":"","filter_attributes":""},"8":{"filter_type":"NONE","filter_tags":"","filter_attributes":""}}}';
$db = JFactory::getDbo();
$u = new JObject();
$u->params = $config ;
$u->element = 'com_content' ;

if($db->updateObject( '#__extensions' , $u , 'element' ))
	echo '覆蓋成功' ;
else
	echo '覆蓋失敗' ;

