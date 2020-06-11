INSERT INTO `nav_items` (`id`, `parent_id`, `title`, `source`, `controller`, `action`, `icon_class`) VALUES
(1, NULL, 'Raiz', 'admin', NULL, NULL, NULL),
(2, 1, 'Painel Inicial', 'admin', NULL, NULL, 'fa-dashboard'),
(3, 1, 'Paginas', 'admin', NULL, NULL, 'fa-clipboard'),
(4, 3, 'Todas as Paginas', 'admin', 'pages', NULL, NULL),
(5, 3, 'Adicionar Pagina', 'admin', 'pages', 'new', NULL),
(6, 3, 'Gerenciar Categorias', 'admin', 'pages-categories', NULL, NULL),
(7, 1, 'Blog', 'admin', NULL, NULL, 'fa-thumb-tack'),
(8, 7, 'Todos os Posts', 'admin', 'posts', NULL, NULL),
(9, 7, 'Adicionar Post', 'admin', 'posts', 'new', NULL),
(10, 7, 'Gerenciar Categorias', 'admin', 'posts-categories', NULL, NULL),
(11, 1, 'Comentarios', 'admin', 'comments', NULL, 'fa-comments'),
(12, 1, 'Biblioteca de Midias', 'admin', NULL, NULL, 'fa-archive'),
(13, 12, 'Todas as Midias', 'admin', 'attachments', NULL, NULL),
(14, 12, 'Adicionar Midia', 'admin', 'attachments', 'new', NULL),
(15, 12, 'Gerenciar Bibliotecas', 'admin', 'libraries', NULL, NULL),
(16, 1, 'Usuarios', 'admin', NULL, NULL, 'fa-user'),
(17, 16, 'Todos os Usuarios', 'admin', 'users', NULL, NULL),
(18, 16, 'Adicionar Usuario', 'admin', 'users', 'new', NULL),
(19, 1, 'Configuracoes', 'admin', NULL, NULL, 'fa-cog'),
(20, 19, 'Opcoes do Sistema', 'admin', 'settings', NULL, NULL),
(21, 19, 'Itens do Menu', 'admin', 'nav-itens', NULL, NULL),
(22, 19, 'Administradores', 'admin', 'administrators', NULL, NULL);

-- --------------------------------------------------------

INSERT INTO `users` (`id`, `first_name`, `last_name`, `registered`, `registered_utc`, `email`, `username`, `password`, `url`, `activation_key`, `is_admin`, `is_active`, `img_1`, `img_2`, `img_3`) VALUES
(1, 'Mayko', 'Kioschi', '2014-09-04 00:00:00', '2014-09-04 00:00:00', 'mkioschi@gmail.com', 'mkioschi', '6d071901727aec1ba6d8e2497ef5b709', NULL, 'asdpf09u34nfiuahvqoiu4o8hvwo748', 1, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

INSERT INTO `categories` (`id`, `parent_id`, `title`, `slug`, `description`, `type`) VALUES
(1, NULL, 'Root', 'root', NULL, 'page'),
(2, NULL, 'Root', 'root', NULL, 'post');