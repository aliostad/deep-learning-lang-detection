drop view SIM_project_emp;
drop view SIM_manager;

create view SIM_project_emp as
SELECT TITLE, RATING, TYPE, PERSON_ID, SIM_DEPT_DEPT_ID, HIRE_DATE, SALARY, STATUS
FROM SIM_person
WHERE TYPE = 'Project Employee';

create or replace TRIGGER SIM_projEmp_trigger
     INSTEAD OF insert ON SIM_project_emp
     FOR EACH ROW
BEGIN
     insert into SIM_person(
        TITLE,
        RATING,
	    TYPE,
        PERSON_ID,
        SIM_DEPT_DEPT_ID,
        HIRE_DATE,
        SALARY,
        STATUS
        )
     VALUES (
	:new.TITLE,
	:new.RATING,
	'Project Employee',
    :new.PERSON_ID,
    :new.SIM_DEPT_DEPT_ID,
    :new.HIRE_DATE,
    :new.SALARY,
    :new.STATUS) ;
END;
/


create view SIM_manager as
SELECT TITLE, BONUS, TYPE, PERSON_ID, SIM_DEPT_DEPT_ID, HIRE_DATE, SALARY, STATUS
FROM SIM_person
WHERE TYPE = 'Manager' ;

create or replace TRIGGER SIM_manager_trigger
     INSTEAD OF insert ON SIM_manager
     FOR EACH ROW
BEGIN
     insert into SIM_person(
        TITLE,
        BONUS,
	    TYPE,
        PERSON_ID,
        SIM_DEPT_DEPT_ID,
        HIRE_DATE,
        SALARY,
        STATUS)
     VALUES (
	:new.TITLE,
	:new.BONUS,
	'Manager'
    :new.PERSON_ID,
    :new.SIM_DEPT_DEPT_ID,
    :new.HIRE_DATE,
    :new.SALARY,
    :new.STATUS) ;
END;
/