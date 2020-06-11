-- *
-- * バージョンアップ用スクリプト
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
-- --------------------------------------------------------------------------------------------------
-- バージョンアップ用スクリプト
-- --------------------------------------------------------------------------------------------------

-- *** システムベーステーブル ***

-- 管理画面ナビゲーション項目マスター
ALTER TABLE _nav_item DROP PRIMARY KEY;                                                                 -- プライマリーキー削除
ALTER TABLE _nav_item DROP INDEX ni_nav_id;                                                                    -- ユニーク制約削除
ALTER TABLE _nav_item ADD PRIMARY KEY (ni_nav_id, ni_id);                                              -- プライマリーキー再設定
ALTER TABLE _nav_item MODIFY ni_name              TEXT                                         NOT NULL;      -- 名前
ALTER TABLE _nav_item ADD ni_url               TEXT                                         NOT NULL;      -- リンク先URL

-- Wiki設定マスター
DELETE FROM wiki_config;
INSERT INTO wiki_config
(wg_id,                     wg_value,    wg_name) VALUES
('password',                '',          '共通パスワード'),
('default_page',            'FrontPage', 'デフォルトページ'),
('auth_type',               'admin',     '認証タイプ'),
('show_page_title',         '1',         'タイトル表示するかどうか'),
('show_page_related',       '1',         '関連ページを表示するかどうか'),
('show_page_attach_files',  '1',         '添付ファイルを表示するかどうか'),
('show_page_last_modified', '1',         '最終更新を表示するかどうか'),
('show_toolbar_for_all_user', '0',         'すべてのユーザにツールバーを表示するかどうか');

