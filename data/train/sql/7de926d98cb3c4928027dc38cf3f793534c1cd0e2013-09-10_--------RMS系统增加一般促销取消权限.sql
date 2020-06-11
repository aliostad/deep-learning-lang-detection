select * from nav_element t where t.element='cmx_promo_cancle';

SELECT *　FROM NAV_ELEMENT_MODE T WHERE T.element='cmx_promo_cancle';

SELECT * FROM NAV_ELEMENT_MODE_ROLE T WHERE T.ELEMENT='cmx_promo_cancle';

SELECT * FROM NAV_ELEMENT_MODE_BASE T WHERE T.ELEMENT='cmx_promo_cancle';

SELECT * FROM sec_form_action_role T WHERE T.ROLE='NORPROMC';

SELECT * FROM NAV_ELEMENT_MODE_ROLE WHERE  ELEMENT='cmx_promo_cancle' FOR UPDATE;

--NAV_ELEMENT_MODE_ROLE是关联RMS的MODE和ROLE权限
--ELEMENT模块名字
--FOLDER存放文件夹
--ROLE权限名称
insert into NAV_ELEMENT_MODE_ROLE values('cmx_promo_cancle','--DEFAULT--','CMX_BBGNBB','NORPROMC');

SELECT * FROM NAV_ELEMENT_MODE WHERE ELEMENT='cmx_promo_cancle';
SELECT * FROM NAV_ELEMENT_MODE_ROLE WHERE ELEMENT='cmx_promo_cancle';

--创建角色
create role NORPROMC;
--授权给余学明
GRANT NORPROMC TO  RMS01;
--授权给RMS业务
--GRANT NORPROMC TO  RMSYW01;

grant NORPROMC to R7907297843;
grant NORPROMC to R7703300024;
grant NORPROMC to R8609130568;
grant NORPROMC to R9006282567;
grant NORPROMC to R8111232324;
grant NORPROMC to R8709024222;
grant NORPROMC to R8603260021;
grant NORPROMC to R8102133520;
grant NORPROMC to R8405010780;
grant NORPROMC to R8911114785;


SELECT * FROM RAINY_USER WHERE USER_ID='RMS01'
--权限写入RAINY_ROLE
SELECT * FROM RAINY_ROLE ORDER BY ROLE_ID FOR UPDATE;
--权限插入岗位
insert into RAINY_POSITION_ROLE(role_id,position_id) values(223,31);
insert into RAINY_POSITION_ROLE(role_id,position_id) values(223,32);
insert into RAINY_POSITION_ROLE(role_id,position_id) values(223,33);
insert into RAINY_POSITION_ROLE(role_id,position_id) values(223,34);
insert into RAINY_POSITION_ROLE(role_id,position_id) values(223,35);
insert into RAINY_POSITION_ROLE(role_id,position_id) values(223,39);


SELECT * FROM sec_form_action_role WHERE ROLE='STPRCCM';
SELECT * FROM SEC_FORM_ACTION WHERE SEC_FORM_ACTION_ID=872;
