set autocommit on;
\p\g
drop table gca01;
\p\g
create table gca01( integer1    i1       with null
		  , integer2    i2       with null
		  , integer4    i4       with null
		  , float4      f4       with null
		  , float8      f8       with null
		  , date        date     with null
		  , money       money    with null
		  , should_read char(30) with null
		  ) with duplicates;
\p\g
insert into gca01( integer1, should_read ) values (-128,'-128');\p\g
insert into gca01( integer1, should_read ) values ( 127, '127');\p\g
insert into gca01( integer2, should_read ) values (-32768,'-32768');\p\g
insert into gca01( integer2, should_read ) values ( 32767, '32767');\p\g
insert into gca01( integer4, should_read ) values (-2147483648,'-2147483648');\p\g
insert into gca01( integer4, should_read ) values ( 2147483647, '2147483647');\p\g
insert into gca01( float4,   should_read ) values (-10.000e+37,'-10.000e+37' );\p\g
insert into gca01( float4,   should_read ) values ( 10.000e+37, '10.000e+37' );\p\g
insert into gca01( float8,   should_read ) values (-10.000e+37,'-10.000e+37' );\p\g
insert into gca01( float8,   should_read ) values ( 10.000e+37, '10.000e+37' );\p\g
insert into gca01( date,     should_read ) values ('01-jan-1582','01-jan-1582');\p\g
insert into gca01( date,     should_read ) values ('31-dec-2382','31-dec-2382');\p\g
insert into gca01( money,    should_read ) values ('$-999999999999.99','$-999999999999.99');\p\g
insert into gca01( money,    should_read ) values ( '$999999999999.99','$ 999999999999.99');
\p\g
select integer1,integer2,integer4,should_read from gca01;\p\g
select integer1, should_read from gca01 where integer1 = -128;\p\g
select integer1, should_read from gca01 where integer1 =  127;\p\g
select integer2, should_read from gca01 where integer2 = -32768;\p\g
select integer2, should_read from gca01 where integer2 =  32767;\p\g
select integer4, should_read from gca01 where integer4 = -2147483648;\p\g
select integer4, should_read from gca01 where integer4 =  2147483647;\p\g
select float4,float8,should_read from gca01;\p\g
select float4, should_read from gca01 where float4 = -1.000e+038;\p\g
select float4, should_read from gca01 where float4 =  1.000e+038;\p\g
select float8, should_read from gca01 where float8 =  1.000e+038;\p\g
select float8, should_read from gca01 where float8 = -1.000e+038;\p\g
select date,money,should_read from gca01;\p\g
select date, should_read from gca01 where date='01-jan-1582';\p\g
select date, should_read from gca01 where date='31-dec-2382';\p\g
select money, should_read from gca01 where money = '$-999999999999.99';\p\g
select money, should_read from gca01 where money =  '$999999999999.99';
\p\g
copy gca01( integer1=    c0tab       with null ('NULL')
	  , integer2=    c0tab       with null ('NULL')
	  , integer4=    c0tab       with null ('NULL')
	  , float4=      c0tab       with null ('NULL')
	  , float8=      c0tab       with null ('NULL')
	  , date=        c0tab       with null ('NULL')
	  , money=       c0tab       with null ('NULL')
	  , should_read= varchar(30) with null ('NULL')
	  , nl= d1 ) into 'gca01a.res';
\p\g
copy gca01( integer1=    c0tab       with null ('NULL')
	  , integer2=    c0tab       with null ('NULL')
	  , integer4=    c0tab       with null ('NULL')
	  , float4=      c0tab       with null ('NULL')
	  , float8=      c0tab       with null ('NULL')
	  , date=        c0tab       with null ('NULL')
	  , money=       c0tab       with null ('NULL')
	  , should_read= varchar(30) with null ('NULL')
	  , nl= d1 ) into 'gca01b.res';
\p\g
copy gca01 ( ) into 'gca01c.res';
\p\g
drop table gca01;
\p\g
create table gca01( integer1    i1       with null
		  , integer2    i2       with null
		  , integer4    i4       with null
		  , float4      f4       with null
		  , float8      f8       with null
		  , date        date     with null
		  , money       money    with null
		  , should_read char(30) with null
		  ) with duplicates;
\p\g
copy gca01( integer1=    c0tab       with null ('NULL')
	  , integer2=    c0tab       with null ('NULL')
	  , integer4=    c0tab       with null ('NULL')
	  , float4=      c0tab       with null ('NULL')
	  , float8=      c0tab       with null ('NULL')
	  , date=        c0tab       with null ('NULL')
	  , money=       c0tab       with null ('NULL')
	  , should_read= varchar(30) with null ('NULL')
	  , nl= d1 ) from 'gca01a.res';
\p\g
select integer1,integer2,integer4,should_read from gca01;\p\g
select integer1,integer2,integer4,should_read from gca01;\p\g
select integer1, should_read from gca01 where integer1 = -128;\p\g
select integer1, should_read from gca01 where integer1 =  127;\p\g
select integer2, should_read from gca01 where integer2 = -32768;\p\g
select integer2, should_read from gca01 where integer2 =  32767;\p\g
select integer4, should_read from gca01 where integer4 = -2147483648;\p\g
select integer4, should_read from gca01 where integer4 =  2147483647;\p\g
select float4,float8,should_read from gca01;\p\g
select float4, should_read from gca01 where float4 = -1.000e+038;\p\g
select float4, should_read from gca01 where float4 =  1.000e+038;\p\g
select float8, should_read from gca01 where float8 =  1.000e+038;\p\g
select float8, should_read from gca01 where float8 = -1.000e+038;\p\g
select date,money,should_read from gca01;\p\g
select date, should_read from gca01 where date='01-jan-1582';\p\g
select date, should_read from gca01 where date='31-dec-2382';\p\g
select money, should_read from gca01 where money = '$-999999999999.99';\p\g
select money, should_read from gca01 where money =  '$999999999999.99';
\p\g
drop table gca01;
\p\g
create table gca01( integer1    i1       with null
		  , integer2    i2       with null
		  , integer4    i4       with null
		  , float4      f4       with null
		  , float8      f8       with null
		  , date        date     with null
		  , money       money    with null
		  , should_read char(30) with null
		  ) with duplicates;
\p\g
copy gca01( integer1=    c0tab       with null ('NULL')
	  , integer2=    c0tab       with null ('NULL')
	  , integer4=    c0tab       with null ('NULL')
	  , float4=      c0tab       with null ('NULL')
	  , float8=      c0tab       with null ('NULL')
	  , date=        c0tab       with null ('NULL')
	  , money=       c0tab       with null ('NULL')
	  , should_read= varchar(30) with null ('NULL')
	  , nl= d1 ) from 'gca01b.res';
\p\g
select integer1,integer2,integer4,should_read from gca01;\p\g
select integer1,integer2,integer4,should_read from gca01;\p\g
select integer1, should_read from gca01 where integer1 = -128;\p\g
select integer1, should_read from gca01 where integer1 =  127;\p\g
select integer2, should_read from gca01 where integer2 = -32768;\p\g
select integer2, should_read from gca01 where integer2 =  32767;\p\g
select integer4, should_read from gca01 where integer4 = -2147483648;\p\g
select integer4, should_read from gca01 where integer4 =  2147483647;\p\g
select float4,float8,should_read from gca01;\p\g
select float4, should_read from gca01 where float4 = -1.000e+038;\p\g
select float4, should_read from gca01 where float4 =  1.000e+038;\p\g
select float8, should_read from gca01 where float8 =  1.000e+038;\p\g
select float8, should_read from gca01 where float8 = -1.000e+038;\p\g
select date,money,should_read from gca01;\p\g
select date, should_read from gca01 where date='01-jan-1582';\p\g
select date, should_read from gca01 where date='31-dec-2382';\p\g
select money, should_read from gca01 where money = '$-999999999999.99';\p\g
select money, should_read from gca01 where money =  '$999999999999.99';\p\g

drop table gca01;
\p\g
create table gca01( integer1    i1       with null
		  , integer2    i2       with null
		  , integer4    i4       with null
		  , float4      f4       with null
		  , float8      f8       with null
		  , date        date     with null
		  , money       money    with null
		  , should_read char(30) with null
		  ) with duplicates;
\p\g
copy gca01 ( ) from 'gca01c.res';
\p\g
select integer1,integer2,integer4,should_read from gca01;
\p\g
select integer1, should_read from gca01 where integer1 = -128;\p\g
select integer1, should_read from gca01 where integer1 = 127;\p\g
select integer2, should_read from gca01 where integer2 = -32768;\p\g
select integer2, should_read from gca01 where integer2 = 32767;\p\g
select integer4, should_read from gca01 where integer4 = -2147483648;\p\g
select integer4, should_read from gca01 where integer4 = 2147483647;\p\g
select float4,float8,should_read from gca01;\p\g
select float4, should_read from gca01 where float4 = -1.000e+038;\p\g
select float4, should_read from gca01 where float4 = 1.000e+038;\p\g
select float8, should_read from gca01 where float8 = 1.000e+038;\p\g
select float8, should_read from gca01 where float8 = -1.000e+038;\p\g
select date, money,should_read from gca01;\p\g
select date, should_read from gca01 where date='01-jan-1582';\p\g
select date, should_read from gca01 where date='31-dec-2382';\p\g
select money, should_read from gca01 where money = '$-999999999999.99';\p\g
select money, should_read from gca01 where money = '$999999999999.99';
\p\g
drop table gca01;
\p\g\q
