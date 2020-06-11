/*group inserts*/
insert into permissions(action, target) VALUES

/*agency access permissions*/       
('record', 'agency'), /*1 : Admin*/
('view', 'agency'), /*2 : RO, Beam, Admin*/
('record', 'agency submitted requirements'),  /*3 : RO, Beam, Admin*/
('view', 'agency submitted requirements'), /*4 :RO, Beam, Admin*/
('process', 'monthly cash allocation'), /*5 : Beam*/
('record', 'monthly report'), /*6 : Beam*/
('view', 'allotment releases'), /*7 : Beam*/
('record', 'allotment releases'), /* 8: Beam */
('view', 'request received'), /*9 : RO, Beam*/
('record', 'request received'), /*10 : RO*/
('record', 'wfp'), /*11: Beam*/
('print', 'comprehensive performance report'), /* 12: Beam*/

/** General reports : BPAC/BEAM**/
('print', 'running balances'), /*13*/
('print', 'total releases'), /*14*/
('print', 'monthly reports'), /*15*/
('print', 'quarterly report'), /*16*/
('print', 'analysis report'), /*17*/
('print', 'fund distribution'), /*18*/
('print', 'agencies with complete requirements'), /*19*/
('print', 'agencies with incomplete requirements'), /*20*/
('print', 'transaction history'),

/*user permissions*/
('record', 'user'), /*21*/
('view', 'user'); /*22*/


insert into groups(name) VALUES
('Recording Officer'),
('BEAM'),
('BPAC'),
('Administrator');


insert into group_perm(group_id, permission_id) VALUES
/*recording officer*/
(1, 2),
(1, 3),
(1, 4),
(1, 6),
(1, 9),
(1, 10),
(1, 19),
(1, 20),
/*BEAM*/
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(2, 16),
(2, 17),
(2, 18),
(2, 19),
(2, 20),
/*BPAC*/
(3, 18),
(3, 7),
(3, 13),
(3, 14),
(3, 15),
(3, 16),
(3, 17),
/*administrative director*/
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 10),
(4, 11),
(4, 12),
(4, 13),
(4, 14),
(4, 15),
(4, 16),
(4, 17),
(4, 18),
(4, 19),
(4, 20),
(4, 21),
(4, 22);

insert into sector(name) values
('Environmental Conservation & Mgt & Human Settlement'),
('Regional Legislative Services'),
('Administrative & Financial management Services'),
('Health Services'),
('Education, Science & Technology'),
('Livelihood, Social Welfare and Protection Services'),
('Employment Promotion & Development & Industrial Peace'),
('Trade Industry & Investment Development'),
('Transportation & Communication Regulation Services'),
('Road Network, Public Infra & Other Development');

insert into quarterly_req(name)
values
('Statement of Allotment, Obligation and balances'),
('Status of Funds'),
('Reports of Detailed Disbursement'),
('Notice of Fund Transfer'),
('Narrative Accomplishment Reports');



/*views*/
CREATE VIEW user_permissions AS
SELECT auth_user.id, auth_user.username,
	groups.name, permissions.action, permissions.target
FROM auth_user
       INNER JOIN user_group ON
       user_group.user_id=auth_user.id
       INNER JOIN groups ON 
       groups.id = user_group.group_id
       INNER JOIN group_perm ON
       group_perm.group_id=groups.id
       INNER JOIN permissions ON 
       permissions.id=group_perm.permission_id;


create table performance_report(
        id serial,
	activity integer not null unique,
	month integer not null,
	received numeric(12, 2) not null default(0.0),
	incurred numeric(12, 2) not null default(0.0),
	remarks character varying(200) not null default '',
	primary key(id),
	foreign key(activity) references wfp_data(id)
	on delete cascade on update cascade
	
);
/*
create view total_approved_budget
as
select allocation_id, agency_id, year, sum(jan) as jan, sum(feb) as feb,
       sum(mar) as mar, sum(apr) as apr, sum(may) as may,
       sum(jun) as jun, sum(jul) as jul, sum(aug) as aug,
       sum(sept) as sept, sum(oct) as oct, sum(nov) as nov,
       sum(`dec`) as `dec`
from wfp_data group by year, allocation_id, agency_id;


create view total_release_util
as
SELECT year, agency_id, allocation_id, month, sum(amount_release) as total_release, sum(amount_utilize) as total_utilize
from fund_rel_util
group by agency_id, allocation_id, month, year;



---triggers
DELIMITER $$

CREATE TRIGGER add_balance
  AFTER INSERT ON wfp_data
  FOR EACH ROW
BEGIN
  DECLARE row_count INTEGER;
  DECLARE alloc VARCHAR(4);

  SELECT COUNT(*)
  INTO row_count
  FROM fund_balances
  WHERE year=NEW.year AND agency_id=NEW.agency_id;

  SELECT name INTO alloc
  FROM allocation WHERE id=NEW.allocation_id;

  IF row_count > 0 AND strcmp(alloc,'PS') > -1 THEN
     UPDATE fund_balances
     SET ps = ps + (NEW.jan+New.feb+NEW.mar+NEW.apr+NEW.may+NEW.jun+NEW.jul+NEW.aug+NEW.sept+NEW.oct+NEW.nov+NEW.dec)
     WHERE agency_id=NEW.agency_id AND year=NEW.year;
  ELSE IF row_count > 0 AND strcmp(alloc,'MOOE') > -1  THEN
     UPDATE fund_balances
     SET mooe = mooe + (NEW.jan+New.feb+NEW.mar+NEW.apr+NEW.may+NEW.jun+NEW.jul+NEW.aug+NEW.sept+NEW.oct+NEW.nov+NEW.dec)
     WHERE agency_id=NEW.agency_id AND year=NEW.year;
  ELSE IF row_count > 0 AND strcmp(alloc,'CO') > -1  THEN
     UPDATE fund_balances
     SET co = co + (NEW.jan+New.feb+NEW.mar+NEW.apr+NEW.may+NEW.jun+NEW.jul+NEW.aug+NEW.sept+NEW.oct+NEW.nov+NEW.dec)
     WHERE agency_id=NEW.agency_id AND year=NEW.year;
  ELSE if row_count <= 0 and strcmp(alloc,'PS') > -1  THEN
     INSERT INTO fund_balances
     (year, agency_id, ps, mooe, co)
     VALUES(NEW.year, NEW.agency_id, (NEW.jan+New.feb+NEW.mar+NEW.apr+NEW.may+NEW.jun+NEW.jul+NEW.aug+NEW.sept+NEW.oct+NEW.nov+NEW.dec), 0, 0);
  ELSE IF row_count<=0 AND strcmp(alloc,'MOOE') > -1  THEN
     INSERT INTO fund_balances
     (year, agency_id, ps, mooe, co)
     VALUES(NEW.year, NEW.agency_id, 0, (NEW.jan+New.feb+NEW.mar+NEW.apr+NEW.may+NEW.jun+NEW.jul+NEW.aug+NEW.sept+NEW.oct+NEW.nov+NEW.dec), 0);
  ELSE
     INSERT INTO fund_balances
     (year, agency_id, ps, mooe, co)
     VALUES(NEW.year, NEW.agency_id, 0, 0, (NEW.jan+New.feb+NEW.mar+NEW.apr+NEW.may+NEW.jun+NEW.jul+NEW.aug+NEW.sept+NEW.oct+NEW.nov+NEW.dec));
  END IF;

END$$
*/
