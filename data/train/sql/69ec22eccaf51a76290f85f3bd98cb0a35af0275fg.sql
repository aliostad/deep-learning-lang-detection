
drop table fg_apt_way;
drop table fg_atc;
drop table fg_apt;

-- airport
create table fg_apt
(
    apt_id      integer primary key,
    apt_code    varchar(4) not null,
    apt_name    varchar(128),
    heliport    boolean DEFAULT false,
    seaport     boolean DEFAULT false,
    elevation   integer
);

-- runway/taxiway
create table fg_apt_way
(
    apt_id      integer references fg_apt(apt_id),
    type        char(1) not null check (type = 't' or type = 'r'),
    num         varchar(3),
    lat         float,
    lng         float,
    abslng      float,
    heading     float,
    length      integer,
    width       integer
);


-- ATC types
drop table fg_atc_type;

create table fg_atc_type
(
    atc_type    integer,
    atc_name    varchar(64),
    
    primary key (atc_type)
);

insert into fg_atc_type (atc_type, atc_name) values (50, 'AWOS/ASOS/ATIS');
insert into fg_atc_type (atc_type, atc_name) values (51, 'Unicom/CTAF/Radio');
insert into fg_atc_type (atc_type, atc_name) values (52, 'Clearance delivery');
insert into fg_atc_type (atc_type, atc_name) values (53, 'Ground');
insert into fg_atc_type (atc_type, atc_name) values (54, 'Tower');
insert into fg_atc_type (atc_type, atc_name) values (55, 'Approach');
insert into fg_atc_type (atc_type, atc_name) values (56, 'Departure');


-- ATC
create table fg_atc
(
    apt_id      integer references fg_apt(apt_id),
    atc_type    integer,
    freq        integer,
    name        varchar(32)
);





drop table fg_nav;
drop table fg_nav_type;
drop table fg_nav_channel;

-- Navaids types
create table fg_nav_type
(
    nav_type    integer,
    nav_name    varchar(32),

    primary key (nav_type)
);

insert into fg_nav_type (nav_type, nav_name) values (2, 'NDB');
insert into fg_nav_type (nav_type, nav_name) values (3, 'VOR/VORTAC/VOR-DME');
insert into fg_nav_type (nav_type, nav_name) values (4, 'LLZ/ILS');
insert into fg_nav_type (nav_type, nav_name) values (5, 'LLZ/LDA/SDF');
insert into fg_nav_type (nav_type, nav_name) values (6, 'GS');
insert into fg_nav_type (nav_type, nav_name) values (7, 'OM');
insert into fg_nav_type (nav_type, nav_name) values (8, 'MM');
insert into fg_nav_type (nav_type, nav_name) values (9, 'IM');
insert into fg_nav_type (nav_type, nav_name) values (12, 'DME');
insert into fg_nav_type (nav_type, nav_name) values (13, 'DME');


-- Navaids
create table fg_nav
(
    nav_type    integer references fg_nav_type(nav_type),
    type_name   varchar(12),
    lat         float,
    lng         float,
    abslng      float,
    elevation   integer,
    freq        integer,
    channelfreq integer,
    range       integer,
    multi       float,
    ident       varchar(8),
    name        varchar(128)
);


-- Nav Channels (TACAN)
create table fg_nav_channel
(
    channel     varchar(4),
    freq        integer,

    primary key (channel)
);



-- Fixes
drop table fg_fix;

create table fg_fix
(
    lat         float,
    lng         float,
    abslng      float,
    name        varchar(5),

    primary key (lat, lng, name)
);


-- Airway

drop table fg_awy;

create table fg_awy
(
    awy_id       integer primary key,

    name_start   varchar(5),
    lat_start    float,
    lng_start    float,

    name_end     varchar(5),
    lat_end      float,
    lng_end      float,

    m            float,
    b            float,

    rl           float,
    rr           float,
    rt           float,
    rb           float,

    enroute      integer check (enroute = 1 or enroute = 2),
    base         integer,
    top          integer,
    seg_name     varchar(128)
);


grant select on
fg_apt, fg_apt_way, fg_atc, fg_atc_type, fg_awy, fg_fix, fg_nav, fg_nav_channel, fg_nav_type
to fgmap;

-- vim: filetype=sql

