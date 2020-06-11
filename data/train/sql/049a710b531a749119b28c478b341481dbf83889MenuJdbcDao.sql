#\u5f97\u5230\u72b6\u6001\u4e3a'\u542f\u7528'\u7684\u83dc\u5355
listDisplayMenu=select * from sys_menu t where t.NAV_ID = ? and t.MENU_STATUS = 1 order by t.MENU_PARENT_ID,t.MENU_SEQ
#\u5f97\u5230\u6240\u6709\u83dc\u5355
listAllMenu=select * from sys_menu t where t.NAV_ID = ? order by t.MENU_PARENT_ID,t.MENU_SEQ
#\u67e5\u8be2\u83dc\u5355
getMenu=select * from sys_menu t where t.MENU_ID = ?
#\u4fee\u6539\u83dc\u5355
updateMenu=update sys_menu set MENU_TITLE = ?,MENU_URL = ?,MENU_SEQ = ?,MENU_STATUS = ? where MENU_ID = ?
#\u63d2\u5165\u83dc\u5355
insertMenu=insert into sys_menu(MENU_ID,MENU_TITLE,MENU_CODE,MENU_URL,MENU_SEQ,MENU_STATUS,MENU_PARENT_ID,MENU_NOTE,NAV_ID) values (?,?,?,?,?,?,?,?,?)
#\u5f97\u5230\u5b50\u8282\u70b9\u6700\u5927code
getChildrenMaxCode=select max(MENU_CODE) from sys_menu s where s.MENU_PARENT_ID = ?
#\u6839\u636e\u7236code\u5220\u9664\u6240\u6709\u5b50\u8282\u70b9
deleteMenusByCode=delete from sys_menu where NAV_ID = ? and MENU_CODE like ?
#\u68c0\u67e5\u5e8f\u53f7\u662f\u5426\u91cd\u590d
checkMenuSeq=select count(1) from sys_menu s where s.NAV_ID = ? and s.MENU_PARENT_ID = ? and MENU_SEQ = ? and MENU_ID != ?