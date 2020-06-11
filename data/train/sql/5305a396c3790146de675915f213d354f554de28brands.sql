INSERT INTO ecs_brand
(
  brand_name,
  brand_logo,
  brand_desc,
  site_url,
  sort_order,
  is_show
)
VALUES
(
  'Fresh',
  'fresh.jpg',
  'Fresh',
  '',
  50,
  TRUE
);

INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('29', '美妆品牌', '', '', '16', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('30', 'Fresh 馥蕾诗', '', '', '29', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('31', '面膜', '', '', '30', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('32', '护肤水', '', '', '30', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('33', '面霜', '', '', '30', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('34', '眼霜', '', '', '30', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('35', '精华', '', '', '30', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('36', '洁面', '', '', '30', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('37', '唇部护理', '', '', '30', '50', '', '', '0', '', '1', '0', '');
INSERT INTO `ecs_category` ( `cat_id`, `cat_name`, `keywords`, `cat_desc`, `parent_id`, `sort_order`, `template_file`, `measure_unit`, `show_in_nav`, `style`, `is_show`, `grade`, `filter_attr` ) VALUES  ('38', '磨砂', '', '', '30', '50', '', '', '0', '', '1', '0', '');

INSERT INTO `ecs_goods` (`goods_id`, `cat_id`, `goods_sn`, `goods_name`, `goods_name_style`, `click_count`, `brand_id`, `provider_name`, `goods_number`, `goods_weight`, `market_price`, `shop_price`, `promote_price`, `promote_start_date`, `promote_end_date`, `warn_number`, `keywords`, `goods_brief`, `goods_desc`, `goods_thumb`, `goods_img`, `original_img`, `is_real`, `extension_code`, `is_on_sale`, `is_alone_sale`, `is_shipping`, `integral`, `add_time`, `sort_order`, `is_delete`, `is_best`, `is_new`, `is_hot`, `is_promote`, `bonus_type_id`, `last_update`, `goods_type`, `seller_note`, `give_integral`, `rank_integral`, `suppliers_id`, `is_check`) VALUES
(33, 36, 'ECS000033', 'Fresh大豆精萃卸妆洁面凝露', '+strong', 9, 1088, '', 1, '0.000', '340.00', '243.00', '0.00', 0, 0, 1, '', '', '', 'images/201404/thumb_img/33_thumb_G_1398358968358.jpg', 'images/201404/goods_img/33_G_1398358968913.jpg', 'images/201404/source_img/33_G_1398358968170.jpg', 1, '', 1, 1, 0, 0, 1398358968, 100, 0, 0, 0, 0, 0, 0, 1399312203, 0, '', -1, -1, 0, NULL),
(34, 31, 'ECS000034', '玫瑰润泽保湿面膜', '+strong', 1, 1088, '', 1, '0.000', '520.00', '359.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/34_thumb_G_1399312449478.jpg', 'images/201405/goods_img/34_G_1399312449988.jpg', 'images/201405/source_img/34_G_1399312449901.jpg', 1, '', 1, 1, 0, 3, 1399312449, 100, 0, 0, 0, 0, 0, 0, 1399312449, 0, '', -1, -1, 0, NULL),
(35, 31, 'ECS000035', '红茶抗皱紧致修护面膜', '+', 0, 1088, '', 1, '0.000', '634.80', '529.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/35_thumb_G_1399312622188.jpg', 'images/201405/goods_img/35_G_1399312622754.jpg', 'images/201405/source_img/35_G_1399312622645.jpg', 1, '', 1, 1, 0, 5, 1399312538, 100, 0, 0, 0, 0, 0, 0, 1399312622, 0, '', -1, -1, 0, NULL),
(36, 31, 'ECS000036', '澄糖亮采磨砂面膜', '+', 0, 1088, '', 1, '0.000', '520.00', '359.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/36_thumb_G_1399312818962.jpg', 'images/201405/goods_img/36_G_1399312818359.jpg', 'images/201405/source_img/36_G_1399312818965.png', 1, '', 1, 1, 0, 3, 1399312747, 100, 0, 0, 0, 0, 0, 0, 1399312818, 0, '', -1, -1, 0, NULL),
(37, 31, 'ECS000037', '意大利白泥控油爽肤面膜', '+', 0, 1088, '', 1, '0.000', '450.00', '309.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/37_thumb_G_1399313101164.jpg', 'images/201405/goods_img/37_G_1399313101187.jpg', 'images/201405/source_img/37_G_1399313101351.png', 1, '', 1, 1, 0, 3, 1399313101, 100, 0, 0, 0, 0, 0, 0, 1399313101, 0, '', -1, -1, 0, NULL),
(38, 36, 'ECS000038', '大豆眼部卸妆液(Fresh美国市场产品)', '+', 0, 1088, '', 1, '0.000', '0.00', '179.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/38_thumb_G_1399313305929.jpg', 'images/201405/goods_img/38_G_1399313305365.jpg', 'images/201405/source_img/38_G_1399313305715.png', 1, '', 1, 1, 0, 1, 1399313305, 100, 0, 0, 0, 0, 0, 0, 1399313305, 0, '', -1, -1, 0, NULL),
(39, 36, 'ECS000039', '玫瑰润泽洁面泡沫', '+', 0, 1088, '', 1, '0.000', '350.00', '243.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/39_thumb_G_1399313459490.jpg', 'images/201405/goods_img/39_G_1399313459117.jpg', 'images/201405/source_img/39_G_1399313459954.png', 1, '', 1, 1, 0, 2, 1399313459, 100, 0, 0, 0, 0, 0, 0, 1399313459, 0, '', -1, -1, 0, NULL),
(40, 30, 'ECS000040', '意大利白泥清透磨砂膏', '+', 2, 1088, '', 1, '0.000', '290.00', '209.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/40_thumb_G_1399313649811.jpg', 'images/201405/goods_img/40_G_1399313649807.jpg', 'images/201405/source_img/40_G_1399313649924.png', 1, '', 1, 1, 0, 2, 1399313649, 100, 0, 0, 0, 0, 0, 0, 1399313730, 0, '', -1, -1, 0, NULL),
(41, 30, 'ECS000041', '睡莲滋润活颜面霜', '+', 0, 1088, '', 1, '0.000', '319.20', '266.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/41_thumb_G_1399313945075.jpg', 'images/201405/goods_img/41_G_1399313945263.jpg', 'images/201405/source_img/41_G_1399313945852.png', 1, '', 1, 1, 0, 2, 1399313945, 100, 0, 0, 0, 0, 0, 0, 1399314365, 0, '', -1, -1, 0, NULL),
(42, 30, 'ECS000042', '玫瑰润泽舒缓凝霜', '+', 0, 1088, '', 1, '0.000', '380.00', '269.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/42_thumb_G_1399314285360.jpg', 'images/201405/goods_img/42_G_1399314285387.jpg', 'images/201405/source_img/42_G_1399314285346.png', 1, '', 1, 1, 0, 2, 1399314252, 100, 0, 0, 0, 0, 0, 0, 1399314285, 0, '', -1, -1, 0, NULL),
(43, 30, 'ECS000043', '睡莲滋润活颜（美国地区产品）', '+', 0, 1088, '', 1, '0.000', '262.80', '219.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/43_thumb_G_1399314447538.jpg', 'images/201405/goods_img/43_G_1399314447006.jpg', 'images/201405/source_img/43_G_1399314447501.png', 1, '', 1, 1, 0, 2, 1399314447, 100, 0, 0, 0, 0, 0, 0, 1399314447, 0, '', -1, -1, 0, NULL),
(44, 30, 'ECS000044', '睡莲眼部凝露(美国地区产品)', '+', 2, 1088, '', 1, '0.000', '370.80', '309.00', '0.00', 0, 0, 1, '', '', '', 'images/201405/thumb_img/44_thumb_G_1399314643616.jpg', 'images/201405/goods_img/44_G_1399314643358.jpg', 'images/201405/source_img/44_G_1399314643419.png', 1, '', 1, 1, 0, 3, 1399314643, 100, 0, 0, 0, 0, 0, 0, 1399314643, 0, '', -1, -1, 0, NULL);
;
commit;
