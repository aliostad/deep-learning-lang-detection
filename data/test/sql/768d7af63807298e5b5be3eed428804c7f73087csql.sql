CREATE TABLE MEMBER(
	MEMBER_ID VARCHAR2(20),
	MEMBER_PW VARCHAR2(15),
	MEMBER_NAME VARCHAR2(20),
	MEMBER_JUMIN1 INT,
	MEMBER_JUMIN2 INT,
	MEMBER_EMAIL VARCHAR2(25),
	MEMBER_EMAIL_GET VARCHAR2(7),
	MEMBER_MOBILE VARCHAR2(13),
	MEMBER_PHONE VARCHAR2(13),
	MEMBER_ZIPCODE VARCHAR2(13),
	MEMBER_ADDR1 VARCHAR2(70),
	MEMBER_ADDR2 VARCHAR2(70),
	MEMBER_ADMIN INT,
	MEMBER_JOIN_DATE DATE
);

CREATE TABLE ZIPCODE (
  ID INT,
  ZIPCODE VARCHAR2(7),
  SIDO VARCHAR2(10),
  GUGUN VARCHAR2(20),
  DONG VARCHAR2(30),
  RI VARCHAR2(70),
  BUNJI VARCHAR2(30),
  PRIMARY KEY (ID)
);

CREATE TABLE GOODS(
	GOODS_NUM INT,
	GOODS_CATEGORY VARCHAR2(20),
	GOODS_NAME VARCHAR2(50),
	GOODS_CONTENT VARCHAR2(3000),
	GOODS_SIZE VARCHAR2(10),
	GOODS_COLOR VARCHAR2(20),
	GOODS_AMOUNT INT,
	GOODS_PRICE INT,
	GOODS_IMAGE VARCHAR2(50),
	GOODS_BEST INT,
	GOODS_DATE DATE,
	PRIMARY KEY(GOODS_NUM)
);

create sequence goods_no_seq 
increment by 1 start with 1 nocache;

CREATE TABLE BASKET(
	BASKET_NUM INT,
	BASKET_MEMBER_ID VARCHAR2(20),
	BASKET_GOODS_NUM INT,
	BASKET_GOODS_AMOUNT INT,
	BASKET_GOODS_SIZE VARCHAR2(20),
	BASKET_GOODS_COLOR VARCHAR2(20),
	BASKET_DATE DATE,
	PRIMARY KEY(BASKET_NUM)
);

create sequence basket_no_seq
increment by 1 start with 1 nocache;

CREATE TABLE GOODS_ORDER(
	ORDER_NUM INT,
	ORDER_TRADE_NUM VARCHAR2(50),
	ORDER_TRANS_NUM VARCHAR2(50),
	ORDER_GOODS_NUM	INT,
	ORDER_GOODS_NAME VARCHAR2(50),
	ORDER_GOODS_AMOUNT INT,
	ORDER_GOODS_SIZE VARCHAR2(20),
	ORDER_GOODS_COLOR VARCHAR2(20),
	ORDER_MEMBER_ID VARCHAR2(20),
	ORDER_RECEIVE_NAME VARCHAR2(20),
	ORDER_RECEIVE_ADDR1 VARCHAR2(70),
	ORDER_RECEIVE_ADDR2 VARCHAR2(70),
	ORDER_RECEIVE_PHONE VARCHAR2(13),
	ORDER_RECEIVE_MOBILE VARCHAR2(13),
	ORDER_MEMO VARCHAR2(3000),
	ORDER_SUM_MONEY INT,
	ORDER_TRADE_TYPE VARCHAR2(20),
	ORDER_TRADE_DATE DATE,
	ORDER_TRADE_PAYER VARCHAR2(20),
	ORDER_DATE DATE,
	ORDER_STATUS INT,
	PRIMARY KEY(ORDER_NUM)
);

create sequence goodsorder_no_seq
increment by 1 start with 1 nocache;

select count(*) from zipcode;

select * from member;

update member set member_admin = 1 where member_id='admin';

		findQuery.append("SELECT * FROM (SELECT GOODS_NUM,");
			findQuery.append("GOODS_CATEGORY, GOODS_NAME, ");
			findQuery.append("GOODS_CONTENT,GOODS_PRICE,GOODS_IMAGE,");
			findQuery.append("GOODS_BEST,GOODS_DATE, rownum r FROM ");
			findQuery.append("GOODS WHERE ");
			
			if (item.equals("new_item")) {
				findQuery.append("GOODS_DATE>=GOODS_DATE-7");
			}else if (item.equals("hit_item")) { 
				findQuery.append("GOODS_BEST=1 ");
			}else{
				findQuery.append("GOODS_CATEGORY=? ");
			}
			findQuery.append("ORDER BY GOODS_NUM DESC) ");
			findQuery.append("WHERE r>=? AND r<=? ");
			
select * from 
(select goods_num, goods_category,goods_name,goods_contents,goods_price,goods_image,goods_best,goods_date, rownum r 
   from goods 
  where goods_date>=goods_date-7
   )
			
select MEMBER_ADMIN from MEMBER where MEMBER_ID='admin'		

select * from user_tables;

select * from goods;
alter table goods modify  GOODS_IMAGE varchar2(200);

desc goods;

select member_pw from member where member_id='admin'

select * from member;

alter table goods_order modify order_trade_type varchar2(40);
select * from basket;

--select MEMBER_ID, MEMBER_PW, MEMBER_JUMIN1,MEMBER_JUMIN2 from member where MEMBER_NAME='�ㅽ씗��
select MEMBER_ID, MEMBER_PW, MEMBER_JUMIN1,MEMBER_JUMIN2 from member where member_name='�띻만��