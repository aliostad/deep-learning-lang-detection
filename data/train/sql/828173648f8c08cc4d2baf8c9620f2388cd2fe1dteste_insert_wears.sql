source database_triggers_insert.sql
source trigger_pan_patient_insert.sql

/*Inserir novo Paciente no PAN de outro Paciente*/

/*Overlap Situação 1 new.start <= Connects.start e Connects.start <= new.end <= Connects.end*/
insert into Wears values ('2010-10-10', '2011-10-10', '001-54245-1555575', 'www.pan1.pt');
/*Overlap Situação 2 Connects.start <= new.start <= Connects.end e Connects.start <= new.end <= Connects.end*/
insert into Wears values ('2011-10-10', '2012-10-10', '001-54245-1555575', 'www.pan1.pt');
/*Overlap Situação 3 Connects.start <= new.start <= Connects.end e new.end >= Connects.end*/
insert into Wears values ('2011-10-10', '2013-10-10', '001-54245-1555575', 'www.pan1.pt');
/*Overlap Situação 4 new.start <= Connects.start e new.end >= Connects.end*/
insert into Wears values ('2010-10-10', '2013-10-10', '001-54245-1555575', 'www.pan1.pt');
/*Sem Overlap Situação 5 new.start <= Connects.start e new.end <= Connects.start*/
insert into Wears values ('2009-10-10', '2010-10-10', '001-54245-1555575', 'www.pan1.pt');
/*Sem Overlap Situação 6 new.start >= Connects.end e new.end >= Connects.end*/
insert into Wears values ('2016-10-10', '2017-10-10', '001-54245-1555575', 'www.pan1.pt');

/*Inserir um Paciente noutro PAN quando este já está ligado a um PAN*/

/*Overlap Situação 1 new.start <= Connects.start e Connects.start <= new.end <= Connects.end*/
insert into Wears values ('2010-10-10', '2011-10-10', '001-54245-1555555', 'www.pan3.pt');
/*Overlap Situação 2 Connects.start <= new.start <= Connects.end e Connects.start <= new.end <= Connects.end*/
insert into Wears values ('2011-10-10', '2012-10-10', '001-54245-1555555', 'www.pan3.pt');
/*Overlap Situação 3 Connects.start <= new.start <= Connects.end e new.end >= Connects.end*/
insert into Wears values ('2011-10-10', '2013-10-10', '001-54245-1555555', 'www.pan3.pt');
/*Overlap Situação 4 new.start <= Connects.start e new.end >= Connects.end*/
insert into Wears values ('2010-10-10', '2013-10-10', '001-54245-1555555', 'www.pan3.pt');
/*Sem Overlap Situação 5 new.start <= Connects.start e new.end <= Connects.start*/
insert into Wears values ('2009-10-10', '2010-10-10', '001-54245-1555555', 'www.pan3.pt');
/*Sem Overlap Situação 6 new.start >= Connects.end e new.end >= Connects.end*/
insert into Wears values ('2016-10-10', '2017-10-10', '001-54245-1555555', 'www.pan3.pt');
