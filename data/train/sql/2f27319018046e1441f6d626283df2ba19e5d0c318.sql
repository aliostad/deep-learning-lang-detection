# --- !Ups

alter table feature add column new_quarter integer default null;
update feature set new_quarter = 19 where quarter = 'Q3_2012';
update feature set new_quarter = 20 where quarter = 'Q4_2012';
update feature set new_quarter = 21 where quarter = 'Q1_2013';
update feature set new_quarter = 22 where quarter = 'Q2_2013';
update feature set new_quarter = 23 where quarter = 'Q3_2013';
update feature set new_quarter = 24 where quarter = 'Q4_2013';
update feature set new_quarter = 25 where quarter = 'Q1_2014';
update feature set new_quarter = 26 where quarter = 'Q2_2014';
update feature set new_quarter = 27 where quarter = 'Q3_2014';
update feature set new_quarter = 28 where quarter = 'Q4_2014';
alter table feature drop column quarter;
alter table feature rename column new_quarter to quarter;

alter table team_staff_levels add column new_quarter integer default null;
update team_staff_levels set new_quarter = 19 where quarter = 'Q3_2012';
update team_staff_levels set new_quarter = 20 where quarter = 'Q4_2012';
update team_staff_levels set new_quarter = 21 where quarter = 'Q1_2013';
update team_staff_levels set new_quarter = 22 where quarter = 'Q2_2013';
update team_staff_levels set new_quarter = 23 where quarter = 'Q3_2013';
update team_staff_levels set new_quarter = 24 where quarter = 'Q4_2013';
update team_staff_levels set new_quarter = 25 where quarter = 'Q1_2014';
update team_staff_levels set new_quarter = 26 where quarter = 'Q2_2014';
update team_staff_levels set new_quarter = 27 where quarter = 'Q3_2014';
update team_staff_levels set new_quarter = 28 where quarter = 'Q4_2014';
alter table team_staff_levels drop constraint pk_team_staff_levels;
alter table team_staff_levels drop column quarter;
alter table team_staff_levels rename column new_quarter to quarter;
alter table team_staff_levels add constraint pk_team_staff_levels primary key (team_id, quarter);
create index ix_team_staff_levels_quarter_2 on team_staff_levels (quarter);

# --- !Downs

alter table feature rename column quarter to new_quarter;
alter table feature add column quarter varchar(7);
update feature set quarter = 'Q3_2012' where new_quarter = 19;
update feature set quarter = 'Q4_2012' where new_quarter = 20;
update feature set quarter = 'Q1_2013' where new_quarter = 21;
update feature set quarter = 'Q2_2013' where new_quarter = 22;
update feature set quarter = 'Q3_2013' where new_quarter = 23;
update feature set quarter = 'Q4_2013' where new_quarter = 24;
update feature set quarter = 'Q1_2014' where new_quarter = 25;
update feature set quarter = 'Q2_2014' where new_quarter = 26;
update feature set quarter = 'Q3_2014' where new_quarter = 27;
update feature set quarter = 'Q4_2014' where new_quarter = 28;
alter table feature drop column new_quarter;


alter table team_staff_levels drop constraint pk_team_staff_levels;
alter table team_staff_levels rename column quarter to new_quarter;
alter table team_staff_levels add column quarter varchar(7);
update team_staff_levels set quarter = 'Q3_2012' where new_quarter = 19;
update team_staff_levels set quarter = 'Q4_2012' where new_quarter = 20;
update team_staff_levels set quarter = 'Q1_2013' where new_quarter = 21;
update team_staff_levels set quarter = 'Q2_2013' where new_quarter = 22;
update team_staff_levels set quarter = 'Q3_2013' where new_quarter = 23;
update team_staff_levels set quarter = 'Q4_2013' where new_quarter = 24;
update team_staff_levels set quarter = 'Q1_2014' where new_quarter = 25;
update team_staff_levels set quarter = 'Q2_2014' where new_quarter = 26;
update team_staff_levels set quarter = 'Q3_2014' where new_quarter = 27;
update team_staff_levels set quarter = 'Q4_2014' where new_quarter = 28;
alter table team_staff_levels drop column new_quarter;
alter table team_staff_levels add constraint pk_team_staff_levels primary key (team_id, quarter);
create index ix_team_staff_levels_quarter_2 on team_staff_levels (quarter);
