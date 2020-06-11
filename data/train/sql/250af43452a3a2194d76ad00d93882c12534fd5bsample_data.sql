-- USER table, replace userid, password hash is for 'invenio' --

insert into invenio_user (userid, password)
values ('invenio','b39f1a8983b9f8ecb20a5a256174463f');

-- VOL_DUMP --
insert into VOL_DUMP values (1,'AC-SUG-1', 1,100, 5, 'Y', 50, 'AA-101', '','','2020-01-01');
insert into VOL_DUMP values (2,'AC-COP-1', 1,1000, 50, 'Y', 50, 'AA-102', '','','2020-01-02');
insert into VOL_DUMP values (3,'AC-SUG-2', 1,1000, 15, 'Y', 50, 'AA-103', '','','2020-01-03');
insert into VOL_DUMP values (4,'AC-IRN-1', 1,100, 5, 'Y', 50, 'AA-104', '','','2020-01-04');
insert into VOL_DUMP values (5,'AC-ZIN-1', 1,100, 5, 'Y', 50, 'AA-105', '','','2020-01-05');

insert into instrument values (1,'Instrument-1', 'INS-1', 'Portfolio-1', 'M1', 10, 30, 200);
insert into instrument values (2,'Instrument-2', 'INS-2', 'Portfolio-2', 'M2', 20, 20, 500);
insert into instrument values (3,'Instrument-3', 'INS-3', 'Portfolio-3', 'M3', 30, 10, 700);

-- FUT_DUMP --
insert into FUT_DUMP values (1, 1, 10, 100, 900, 'Basic', 500, 20, 10, 1, 0.1);
insert into FUT_DUMP values (2, 2, 20, 200, 1900, 'Adavanced', 550, 20, 10, 1,0.2);
insert into FUT_DUMP values (3, 3, 30, 300, 2900, 'Priority', 900, 20, 10, 1,0.3);
insert into FUT_DUMP values (4, 1, 40, 400, 3900, 'Basic', 10, 20, 10, 1,0.4);
insert into FUT_DUMP values (5, 1, 50, 500, 5000, 'Basic', 55, 20, 10, 1, 0.5);

-- OPT_DUMP --
insert into OPT_DUMP values (1, 1, 10, 1, 10.1, 1.1, 2.0, 100, 'Customer-1', 2.2, 3.1, 'ABC', 'Y', 'N', 'Y', '2020-01-01', 'BUY', 500, 'CONTRACT-1', 'Y', 10.2, 'L-1', 10);
insert into OPT_DUMP values (2, 2, 20, 2, 10.2, 1.2, 1.9, 200, 'Customer-2', 2.2, 3.2, 'MNO', 'N', 'Y', 'N', '2020-01-02', 'BUY', 1500, 'CONTRACT-2', 'N', 10.8, 'L-2', 20);
insert into OPT_DUMP values (3, 3, 30, 3, 10.3, 1.3, 1.8, 300, 'Customer-3', 2.3, 3.3, 'XYZ', 'Y', 'N', 'Y', '2020-01-03', 'BUY', 2500, 'CONTRACT-3', 'Y', 10.2, 'L-3', 30);
insert into OPT_DUMP values (4, 1, 40, 4, 10.4, 1.4, 1.7, 400, 'Customer-4', 2.4, 3.4, 'ABC', 'N', 'N', 'Y', '2020-01-04', 'BUY', 4500, 'CONTRACT-4', 'Y', 10.2, 'L-4', 40);
insert into OPT_DUMP values (5, 2, 50, 5, 10.5, 1.5, 1.6, 500, 'Customer-5', 2.5, 3.5, 'MNO', 'Y', 'N', 'N', '2020-01-05', 'BUY', 5500, 'CONTRACT-5', 'Y', 10.9, 'L-5', 50);
insert into OPT_DUMP values (6, 3, 60, 6, 10.6, 1.6, 1.5, 600, 'Customer-6', 2.6, 3.6, 'XYZ', 'N', 'N', 'Y', '2020-01-06', 'SELL', 7500, 'CONTRACT-6', 'Y', 10.2, 'L-6', 60);
insert into OPT_DUMP values (7, 1, 70, 7, 10.7, 1.7, 1.4, 700, 'Customer-7', 2.7, 3.7, 'ABC', 'N', 'Y', 'Y', '2020-01-07', 'SELL', 50, 'CONTRACT-7', 'N', 10.2, 'L-7', 70);
insert into OPT_DUMP values (8, 2, 80, 8, 10.8, 1.8, 1.3, 800, 'Customer-8', 2.8, 3.8, 'MNO', 'N', 'Y', 'Y', '2020-01-08', 'SELL', 5, 'CONTRACT-8', 'Y', 10.2, 'L-8', 80);
insert into OPT_DUMP values (9, 3, 90, 9, 10.9, 1.9, 1.2, 900, 'Customer-9', 2.9, 3.9, 'XYZ', 'Y', 'N', 'Y', '2020-01-09', 'SELL', 500, 'CONTRACT-9', 'Y', 10.2, 'L-9', 90);
insert into OPT_DUMP values (10, 1, 100, 18, 20, 2.0, 1.1, 1000, 'Customer-10', 3.0, 3.0, 'ABC', 'Y', 'N', 'N', '2020-01-10', 'SELL', 500, 'CONTRACT-10', 'N', 10.1, 'L-10', 100);

-- M_US_DUMP --
insert into M_US_DUMP values (1, 1, 'STR-1', 10, 1, 10.0, 1.4, 1.0, 101, 1, '2020-01-01', 'instrument-1');
insert into M_US_DUMP values (2, 2, 'STR-2', 11, 2, 10.5, 1.3, 2.0, 102, 2, '2020-01-02', 'instrument-2');
insert into M_US_DUMP values (3, 3, 'STR-3', 12, 3, 10.2, 1.2, 3.0, 103, 3, '2020-01-03', 'instrument-3');
insert into M_US_DUMP values (4, 1, 'STR-4', 13, 4, 10.1, 1.1, 4.0, 104, 4, '2020-01-04', 'instrument-4');
insert into M_US_DUMP values (5, 1, 'STR-5', 14, 5, 10.2, 1.0, 5.0, 100, 5, '2020-01-05', 'instrument-5');



