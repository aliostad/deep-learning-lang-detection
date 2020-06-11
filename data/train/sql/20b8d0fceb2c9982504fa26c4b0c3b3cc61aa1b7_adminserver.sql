-- *
-- * データ登録スクリプト「サーバ管理」
-- *
-- * PHP versions 5
-- *
-- * LICENSE: This source file is licensed under the terms of the GNU General Public License.
-- *
-- * @package    Magic3 Framework
-- * @author     平田直毅(Naoki Hirata) <naoki@aplo.co.jp>
-- * @copyright  Copyright 2006-2015 Magic3 Project.
-- * @license    http://www.gnu.org/copyleft/gpl.html  GPL License
-- * @version    SVN: $Id$
-- * @link       http://www.magic3.org
-- *
-- [サーバ管理]
-- サーバ管理を行う。

-- システム設定マスター(PCサイト非公開)
UPDATE _system_config SET sc_value = '0' WHERE sc_id = 'site_pc_in_public';
UPDATE _system_config SET sc_value = 'serveradmin' WHERE sc_id = 'system_type';
-- 管理画面をSSL対応
UPDATE _system_config SET sc_value = '1' WHERE sc_id = 'use_ssl_admin';

-- サイト定義マスター
DELETE FROM _site_def WHERE sd_id = 'site_name';
INSERT INTO _site_def
(sd_id,                  sd_language_id, sd_value,         sd_name) VALUES
('site_name',            'ja',           'サーバ管理',               'サイト名');

-- ページIDマスター
-- スマートフォン,携帯のアクセスポイントを隠す
UPDATE _page_id SET pg_active = true  WHERE pg_id = 'index' AND pg_type = 0;
UPDATE _page_id SET pg_active = false WHERE pg_id = 's_index' AND pg_type = 0;
UPDATE _page_id SET pg_active = false WHERE pg_id = 'm_index' AND pg_type = 0;

-- 管理画面メニューデータ
DELETE FROM _nav_item WHERE ni_nav_id = 'admin_menu';
DELETE FROM _nav_item WHERE ni_nav_id = 'admin_menu.en';
INSERT INTO _nav_item
(ni_id, ni_parent_id, ni_index, ni_nav_id,    ni_task_id,        ni_view_control, ni_param, ni_name,                ni_help_title,          ni_help_body) VALUES
(200,   0,            2,        'admin_menu', '_adminserver',    0,               '',       'サーバ管理',         '',                     ''),
(201,   200,          0,        'admin_menu', 'serverinfo',      0,               '',       'サーバ情報',           'サーバ情報',           'このサーバについての情報を表示します。'),
(202,   200,          1,        'admin_menu', 'sitelist',        0,               '',       'サイト一覧',           'サイト一覧',           '運営中のサイトの情報を表示します。'),
(203,   200,          2,        'admin_menu', 'servertool',      0,               '',       'サーバ管理ツール',     'サーバ管理ツール',     '使用可能な外部のサーバ管理ツールを表示します。'),
(299,   0,            3,        'admin_menu', '_299',            1,               '',       '改行',                 '',                     ''),
(300,   0,            4,        'admin_menu', '_config',         0,               '',       'システム管理',         '',                     ''),
(301,   300,          0,        'admin_menu', 'configsite',      0,               '',       '基本情報',             '基本情報',             'サイト運営に必要な情報を設定します。'),
(302,   300,          1,        'admin_menu', 'configsys',       0,               '',       'システム情報',         'システム情報',         'システム全体の設定、運用状況を管理します。'),
(303,   300,          2,        'admin_menu', 'mainte',          0,               '',       'メンテナンス', 'メンテナンス', 'ファイルやDBなどのメンテナンスを行います。');
