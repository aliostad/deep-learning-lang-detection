source database_triggers_update.sql
source trigger_pan_device_update.sql

/*Com overlap*/
/*Aumentar new.end com overlap*/
update Connects set start = '2013-11-25', end = '2015-12-02' where pan = 'www.pan3.pt';
/*Diminuir new.start com overlap*/
update Connects set start = '2012-10-25', end = '2013-12-01' where pan = 'www.pan3.pt';
/*Diminuir new.end e diminuir new.start com overlap*/
update Connects set start = '2011-11-24', end = '2013-11-20' where pan = 'www.pan3.pt';
/*Aumentar new.end e diminuir new.start com overlap*/
update Connects set start = '2011-11-24', end = '2015-12-02' where pan = 'www.pan3.pt';
/*Aumentar new.start e aumentar new.start com overlap*/
update Connects set start = '2013-11-26', end = '2015-12-02' where pan = 'www.pan3.pt';


/*Sem overlap*/
/*Diminuir new.end sem overlap*/
update Connects set start = '2013-11-25', end = '2013-11-28' where pan = 'www.pan3.pt';
/*Aumentar new.end sem overlap*/
update Connects set start = '2013-11-25', end = '2013-12-02' where pan = 'www.pan3.pt';
/*Diminuir new.start sem overlap*/
update Connects set start = '2013-10-25', end = '2013-12-01' where pan = 'www.pan3.pt';
/*Aumentar new.start sem overlap*/
update Connects set start = '2013-11-26', end = '2013-12-01' where pan = 'www.pan3.pt';
/*Diminuir new.end e diminuir new.start sem overlap*/
update Connects set start = '2013-11-24', end = '2013-11-20' where pan = 'www.pan3.pt';
/*Diminuir new.end e aumentar new.start sem overlap*/
update Connects set start = '2013-11-26', end = '2013-11-30' where pan = 'www.pan3.pt';
/*Aumentar new.end e diminuir new.start sem overlap*/
update Connects set start = '2013-11-24', end = '2013-12-02' where pan = 'www.pan3.pt';
/*Aumentar new.end e aumentar new.start sem overlap*/
update Connects set start = '2013-11-26', end = '2013-12-02' where pan = 'www.pan3.pt';
