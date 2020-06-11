CREATE TABLE news (id INTEGER PRIMARY KEY AUTOINCREMENT, nid INTEGER, node_created NUMERIC, node_title TEXT, field_thumbnails TEXT, field_channel TEXT, field_newsfrom TEXT, field_summary TEXT, body_1 TEXT, body_2 TEXT);



CREATE TABLE "update_log" (id INTEGER PRIMARY KEY AUTOINCREMENT, channel_id INTEGER, channel_name TEXT, update_time NUMERIC);


CREATE TABLE nav_id_map (nav_id_mapid INTEGER PRIMARY KEY AUTOINCREMENT, nav_name TEXT, nav_id INTEGER);

INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (1,'头条',15);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (2,'要闻',16);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (3,'生产经营',17);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (4,'东风党建',18);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (5,'和谐东风',19);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (6,'东风人',20);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (7,'东风文艺',21);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (8,'专题报道',22);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (9,'四城视点',23);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (10,'专题',24);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (11,'企业',25);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (12,'对话',26);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (13,'观点',27);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (14,'旅游资讯',28);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (15,'“驾”临天下',29);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (16,'名车靓影',30);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (17,'城市约会',31);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (18,'乐途影像',32);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (19,'名家专栏',33);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (20,'微博•贴士邦',34);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (21,'播报',35);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (22,'国际前沿',36);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (23,'新车评测',37);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (24,'政能量',38);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (25,'创新观察',39);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (26,'人物专访',40);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (27,'特别关注',41);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (28,'特稿',42);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (29,'设计•研究',43);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (30,'试验•测试',44);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (31,'工艺•材料',45);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (32,'公告牌',46);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (33,'行业资讯',47);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (34,'工作研究',48);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (35,'故障维修',49);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (36,'技术改造',50);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (37,'节能技术',51);
INSERT INTO nav_id_map (nav_id_mapid,nav_name,nav_id) VALUES (38,'汽车研究',52);

CREATE TABLE ad_cache (ad_cacheid INTEGER PRIMARY KEY AUTOINCREMENT, nid INTEGER, node_changed NUMERIC, node_title TEXT, field_thumbnails TEXT);

INSERT INTO ad_cache (ad_cacheid,nid,node_changed,node_title,field_thumbnails) VALUES (1,1136,0,'软件启动','');
INSERT INTO ad_cache (ad_cacheid,nid,node_changed,node_title,field_thumbnails) VALUES (2,1160,0,'东风汽车报','');
INSERT INTO ad_cache (ad_cacheid,nid,node_changed,node_title,field_thumbnails) VALUES (3,1161,0,'东风','');
INSERT INTO ad_cache (ad_cacheid,nid,node_changed,node_title,field_thumbnails) VALUES (4,1162,0,'汽车之旅','');
INSERT INTO ad_cache (ad_cacheid,nid,node_changed,node_title,field_thumbnails) VALUES (5,1163,0,'汽车科技','');
INSERT INTO ad_cache (ad_cacheid,nid,node_changed,node_title,field_thumbnails) VALUES (6,1164,0,'装备维修技术','');
