listDisplayNavigator=select * from sys_navigator t where t.NAV_STATUS = 1 order by t.NAV_SEQ

queryNavigatorList=select * from sys_navigator t order by t.NAV_SEQ

saveNavigator=insert into sys_navigator(NAV_ID, NAV_NAME, NAV_URL, NAV_STATUS,NAV_SEQ,NAV_NOTE) values(?,?,?,?,?,?)

delNavigator=delete from sys_navigator where NAV_ID = ?

getNavigator=select * from sys_navigator where NAV_ID=?

updateNavigator=update sys_navigator set NAV_NAME=?,NAV_URL=?,NAV_STATUS=?,NAV_SEQ=?,NAV_NOTE=? where NAV_ID=?

getSeqWhenCreate=select count(1) from sys_navigator where NAV_SEQ=?

getSeqWhenUpdate=select count(1) from sys_navigator where NAV_ID !=? AND NAV_SEQ=?