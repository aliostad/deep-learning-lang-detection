-- --------------------------------------------------------
-- 对“快速访问”进行中文化翻译
-- --------------------------------------------------------
-- INSERT INTO `ps_quick_access_lang` (`id_quick_access`, `id_lang`, `name`) VALUES
-- (1, 1, 'Home'),
UPDATE ps_quick_access_lang SET name='起始页'       WHERE id_lang=1 AND name='Home';
-- (2, 1, 'My Shop'),
UPDATE ps_quick_access_lang SET name='前往商店'     WHERE id_lang=1 AND name='My Shop';
-- (3, 1, 'New category'),
UPDATE ps_quick_access_lang SET name='添加商品类别' WHERE id_lang=1 AND name='New category';
-- (4, 1, 'New product'),
UPDATE ps_quick_access_lang SET name='添加商品'     WHERE id_lang=1 AND name='New product';
-- (5, 1, 'New voucher');
UPDATE ps_quick_access_lang SET name='添加优惠券'   WHERE id_lang=1 AND name='New voucher';
