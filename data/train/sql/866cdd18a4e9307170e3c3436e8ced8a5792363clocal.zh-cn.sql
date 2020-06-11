-- Insert data into `eps_block`;
INSERT INTO `eps_block` (`id`, `type`, `title`, `content`) VALUES
(1, 'latestArticle', '最新文章', '{"category":"0","limit":"7"}'),
(2, 'hotArticle', '热门文章', '{"category":"0","limit":"7"}'),
(3, 'latestProduct', '最新产品', '{"category":"0","limit":"3","image":"show"}'),
(4, 'hotProduct', '热门产品', '{"category":"0","limit":"3","image":"show"}'),
(5, 'slide', '幻灯片', ''),
(6, 'articleTree', '文章分类', '{"showChildren":"0"}'),
(7, 'productTree', '产品分类', '{"showChildren":"0"}'),
(8, 'blogTree', '博客分类', '{"showChildren":"1"}'),
(9, 'contact', '联系我们', ''),
(10, 'about', '公司简介', ''),
(11, 'links', '友情链接', '');
