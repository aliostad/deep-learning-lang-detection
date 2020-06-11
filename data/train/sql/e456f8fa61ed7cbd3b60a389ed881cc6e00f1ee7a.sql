drop view textbooks;
drop view sports;
drop view society;
drop view science;
drop view law;
drop view lang;
drop view history;
drop view health;
drop view crime;
drop view crafts;
drop view computing;
drop view business;
drop view biographies;
drop view arts;
drop view lit;
drop view action;
drop view child;
drop view comics;
drop view historical;
drop view humour;
drop view politics;
drop view reference;
drop view romance;
drop view study;
drop view travel;
drop view religion;
create view 











	textbooks as (select * from books where genre='Textbooks ');
create view 











	sports as (select * from books where genre='Sports ');
create view 











	society as (select * from books where genre='Society & Social Sciences ');
create view 











	science as (select * from books where genre='Sciences Technology & Medicine ');
create view 











	law as (select * from books where genre='Law ');
create view 











	lang as (select * from books where genre='Language, Linguistics & Writing');	
create view 











	history as (select * from books where genre='History ');
create view 











	health as (select * from books where genre='Health Family & Personal Development');
create view 











	fantasy as (select * from books where genre='Fantasy Horror & Science Fiction');
create view 











	crime as (select * from books where genre='Crime Thriller & Mystery ');
create view 











	crafts as (select * from books where genre='Crafts Home & Lifestyle');
create view 











	computing as (select * from books where genre='Computing Internet & Digital Media');
create view 











	business as (select * from books where genre='Business & Economics ');
create view 











	biographies as (select * from books where genre='Biographies Diaries & True Accounts ');	
create view 











	arts as (select * from books where genre='Arts Film & Photography ');
create view 











	lit as ( select * from books where genre = 'Literature & Fiction');
create view 











	action as (select * from books where genre='Action & Adventure');
create view 











	child as (select * from books where genre='Childrens & Young Adult');
create view 











	comics as (select * from books where genre='Comics & Mangas');
create view 











	historical as (select * from books where genre='Historical Fiction');
create view 











	humour as (select * from books where genre='Humour');
create view 











	politics as (select * from books where genre='Politics');
create view reference as (select * from books where genre='Reference');
create view romance as (select * from books where genre='Romance');
create view study as (select * from books where genre='Study Aids & Exam Preparations');
create view travel as (select * from books where genre='Travel');
create view religion as (select * from books where genre='Religion ');