copy t_fuben(id, name, icon, type, level, quality, des) from stdin;
1	副本1	newResources/fuben/fb1.png	1	1	1	副本描述1
2	副本2	newResources/fuben/fb2.png	1	1	1	test	
3	副本3	newResources/fuben/fb3.png	1	1	1	副本test3	
\.


copy t_city(id, name, icon, level, quality, tili, exp, coin, des) from stdin;
1	关卡1	newResources/heroCard/action_module/zhan_jiang_mifuren.png	1	1	1	50	500	关卡描述1
2	关卡2	newResources/heroCard/action_module/zhan_jiang_lukang.png	1	1	1	50	500	关卡描述2
3	关卡3	newResources/heroCard/action_module/zhan_jiang_manchong.png	1	1	1	50	500	关卡描述3
\.

copy t_city_card(id, city_id, card_id, pos) from stdin;
1	1 	
\.