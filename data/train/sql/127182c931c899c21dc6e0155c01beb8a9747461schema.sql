drop table if exists entries;
create table entries (
  id integer primary key autoincrement,
  title text not null,
  text text not null
);

drop table if exists nav;
create table nav (
  id integer primary key autoincrement,
  name text not null,
  url text not null
);

INSERT INTO nav ('name', 'url') VALUES ('帮助', '/');
INSERT INTO nav ('name', 'url') VALUES ('自动发布', '/public');
INSERT INTO nav ('name', 'url') VALUES ('百度', 'http://www.baidu.com');
INSERT INTO nav ('name', 'url') VALUES ('文档svn', 'svn://192.168.1.2/doc');
INSERT INTO nav ('name', 'url') VALUES ('资源svn', 'svn://192.168.1.2/element');
INSERT INTO nav ('name', 'url') VALUES ('数据分析', '/analysis');

drop table if exists analysis_menu;
create table analysis_menu (
  id integer primary key autoincrement,
  name text not null,
  url text not null,
  group_id integer not null,
  sort_id integer not null
);

INSERT INTO analysis_menu ('name', 'url', 'group_id', 'sort_id') VALUES ('货币和积分', '/analysis', '2', '0');
INSERT INTO analysis_menu ('name', 'url', 'group_id', 'sort_id') VALUES ('金币', '/analysis_gold', '2', '1');
INSERT INTO analysis_menu ('name', 'url', 'group_id', 'sort_id') VALUES ('钻石', '/analysis_diamond', '2', '2');
INSERT INTO analysis_menu ('name', 'url', 'group_id', 'sort_id') VALUES ('道具', '/analysis', '3', '0');
INSERT INTO analysis_menu ('name', 'url', 'group_id', 'sort_id') VALUES ('道具查询', '/analysis_item', '3', '1');
INSERT INTO analysis_menu ('name', 'url', 'group_id', 'sort_id') VALUES ('玩家', '/analysis', '1', '0');
INSERT INTO analysis_menu ('name', 'url', 'group_id', 'sort_id') VALUES ('玩家等级', '/analysis_lv', '1', '1');
