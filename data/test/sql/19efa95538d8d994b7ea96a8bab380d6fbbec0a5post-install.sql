
-- POST INSTALLATION INSERTS

-- INSERT DSTs
insert into _db_pref_DST values (1, 'Africa / Egypt', 39312000, 52531200, 5, 5, 5, 4, 'FREQ=1;INTERVAL=1;BYMONTH=4;BYDAY=-15', 'FREQ=1;INTERVAL=1;BYMONTH=9;BYDAY=-14');
insert into _db_pref_DST values (2, 'Africa / Namibia', 52531200, 39312000, 1, 0, 1, 0, 'FREQ=1;INTERVAL=1;BYMONTH=9;BYDAY=10', 'FREQ=1;INTERVAL=1;BYMONTH=4;BYDAY=10');
insert into _db_pref_DST values (3, 'Asia / USSR (former) - most states', 36633600, 55123200, 5, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=3;BYDAY=-10', 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=-10');
insert into _db_pref_DST values (4, 'Asia / Iraq', 39312000, 55123200, 0, 0, 0, 0, 'FREQ=1;INTERVAL=1;BYMONTH=4;BYMONTHDAY=1', 'FREQ=1;INTERVAL=1;BYMONTH=10;BYMONTHDAY=1');
insert into _db_pref_DST values (5, 'Asia / Lebanon, Kirgizstan', 36633600, 55123200, 5, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=3;BYDAY=-10', 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=-10');
insert into _db_pref_DST values (6, 'Asia / Syria', 39312000, 55123200, 0, 0, 0, 0, 'FREQ=1;INTERVAL=1;BYMONTH=4;BYMONTHDAY=1', 'FREQ=1;INTERVAL=1;BYMONTH=10;BYMONTHDAY=1');
insert into _db_pref_DST values (7, 'Australasia / Australia, New South Wales', 55123200, 36633600, 5, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=-10', 'FREQ=1;INTERVAL=1;BYMONTH=3;BYDAY=-10');
insert into _db_pref_DST values (8, 'Australasia / Australia - Tasmania', 55123200, 36633600, 1, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=10', 'FREQ=1;INTERVAL=1;BYMONTH=3;BYDAY=-10');
insert into _db_pref_DST values (9, 'Australasia / New Zealand, Chatham', 55123200, 36633600, 1, 0, 3, 0, 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=10', 'FREQ=1;INTERVAL=1;BYMONTH=3;BYDAY=30');
insert into _db_pref_DST values (10, 'Australasia / Tonga', 57801600, 31536000, 1, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=11;BYDAY=10', 'FREQ=1;INTERVAL=1;BYMONTH=1;BYDAY=-10');
insert into _db_pref_DST values (11, 'Europe / European Union, UK, Greenland', 36633600, 55123200, 5, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=3;BYDAY=-10', 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=-10');
insert into _db_pref_DST values (12, 'Europe / Russia', 36633600, 55123200, 5, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=3;BYDAY=-10', 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=-10');
insert into _db_pref_DST values (13, 'North America / United States, Canada, Mexico', 39312000, 55123200, 1, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=4;BYDAY=10', 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=-10');
insert into _db_pref_DST values (14, 'North America / Cuba', 39312000, 55123200, 0, 0, 5, 0, 'FREQ=1;INTERVAL=1;BYMONTH=4;BYMONTHDAY=1', 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=-10');
insert into _db_pref_DST values (15, 'South America / Chile', 55123200, 36633600, 2, 6, 2, 6, 'FREQ=1;INTERVAL=1;BYMONTH=10;BYDAY=26', 'FREQ=1;INTERVAL=1;BYMONTH=3;BYDAY=26');
insert into _db_pref_DST values (16, 'South America / Paraguay', 52531200, 39312000, 1, 0, 1, 0, 'FREQ=1;INTERVAL=1;BYMONTH=9;BYDAY=10', 'FREQ=1;INTERVAL=1;BYMONTH=4;BYDAY=10');
insert into _db_pref_DST values (17, 'South America / Falklands', 53136000, 39744000, 1, 0, 1, 0, 'FREQ=1;INTERVAL=1;BYMONTH=9;BYDAY=10', 'FREQ=1;INTERVAL=1;BYMONTH=4;BYDAY=10');

-- DEFAULT CALENDAR 
insert into _db_pref_Calendars (title,type,options,owner,description) values ('Default Calendar',0,77,1,'Default Site Calendar');

-- DEFAULT CALENDAR MEMBERS
insert into _db_pref_CalendarMembers (cid,rid,rtype,access_lvl) values (1,0,0,0);
insert into _db_pref_CalendarMembers (cid,rid,rtype,access_lvl) values (1,0,1,0);

-- DEFAULT EVENT TYPES
insert into _db_pref_EventTypes (id,calendar,name) values('1',1,'Appointment');
insert into _db_pref_EventTypes (id,calendar,name) values('2',1,'Birthday');
insert into _db_pref_EventTypes (id,calendar,name) values('4',1,'Call');
insert into _db_pref_EventTypes (id,calendar,name) values('8',1,'Holiday');
insert into _db_pref_EventTypes (id,calendar,name) values('16',1,'Interview');
insert into _db_pref_EventTypes (id,calendar,name) values('32',1,'Meeting');
insert into _db_pref_EventTypes (id,calendar,name) values('64',1,'Net Event');
insert into _db_pref_EventTypes (id,calendar,name) values('128',1,'Other');
insert into _db_pref_EventTypes (id,calendar,name) values('256',1,'Reminder');
insert into _db_pref_EventTypes (id,calendar,name) values('512',1,'Travel');
insert into _db_pref_EventTypes (id,calendar,name) values('1024',1,'Vacation');

-- INITIAL USERS
insert into _db_pref_Users (id,userid,name,pass,access_lvl) values(1,'admin','Administrator','4cb9c8a8048fd02294477fcb1a41191a',1);
insert into _db_pref_Users (id,userid,pass,access_lvl) values(0,'_cal_default_','ENABLED',0);

-- DEFAULT OPTIONS
insert into _db_pref_UserOptions (e_popup,e_n_popup,default_view,theme,hour_format,week_start,workday_start_hr,workday_end_hr,time_interval,timezone,dst,id,default_cal,e_size,e_collapse,e_typename)
        values (1,1,'m','default',12,1,9,18,2,0,-1,0,1,0,0,0);

-- DEFAULT NAVBAR
insert into _db_pref_NavModules (module, mod_order, uid, leftright) values ('mini_cal',1,0,0);
insert into _db_pref_NavModules (module, mod_order, uid, leftright) values ('goto_date',2,0,0);
insert into _db_pref_NavModules (module, mod_order, uid, leftright) values ('event_search',3,0,0);
insert into _db_pref_NavModules (module, mod_order, uid, leftright) values ('calendar_picker',4,0,0);
insert into _db_pref_NavModules (module, mod_order, uid, leftright) values ('calendar_links',6,0,0);
insert into _db_pref_NavModules (module, mod_order, uid, leftright) values ('event_filter',5,0,0);
insert into _db_pref_NavModules (module, mod_order, uid, leftright) values ('today_link',0,0,0);

-- FORCE DEFAULT OPTIONS FOR ALL USERS
insert into _db_pref_GlobalSettings (variable, setting) values ('_CAL_FORCE_DEFAULT_OPTS_', '1');

