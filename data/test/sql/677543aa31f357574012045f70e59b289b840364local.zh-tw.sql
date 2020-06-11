-- Insert data into `eps_block`;
INSERT INTO `eps_block` (`id`, `type`, `title`, `content`) VALUES
(1, 'latestArticle', '最新文章', '{"category":"0","limit":"7"}'),
(2, 'hotArticle', '熱門文章', '{"category":"0","limit":"7"}'),
(3, 'latestProduct', '最新産品', '{"category":"0","limit":"3","image":"show"}'),
(4, 'hotProduct', '熱門産品', '{"category":"0","limit":"3","image":"show"}'),
(5, 'slide', '幻燈片', ''),
(6, 'articleTree', '文章分類', '{"showChildren":"0"}'),
(7, 'productTree', '産品分類', '{"showChildren":"0"}'),
(8, 'blogTree', '博客分類', '{"showChildren":"1"}'),
(9, 'contact', '聯系我們', ''),
(10, 'about', '公司簡介', ''),
(11, 'links', '友情鏈接', '');
