create table student(
  id integer primary key autoincrement,
  name varchar(20) not null,
  age integer not null
);

insert into student(name,age ) values('jack',26);
insert into student(name,age ) values('tom',18);
insert into student(name,age ) values('史泰龙',56);
insert into student(name,age ) values('泰森',38);

select * from student;


drop table Product;
drop table tb_Product;
drop table User;
drop table tb_User;
drop table tb_order;
drop table sqlite_sequence;


--创建产品表（Product）
create table tb_product(
  productId integer primary key autoincrement,
  name varchar(50) not null,
  price numeric(5,2) not null
);

--创建用户表（User）
create table tb_user(
  userId integer primary key autoincrement,
  name varchar(50) not null
);

--创建订单表（Order）
create table tb_order(
  orderId integer primary key autoincrement,
  orderTotalPrice numeric(10,2) not null,
  userId integer,
  foreign key(userId) references tb_user(userId)
);

--创建订单项表（OrderItem）
create table tb_orderitem(
  orderItemId integer primary key autoincrement,
  productId integer,
  amount integer,
  orderItemPrice numeric(8,2) not null,
  orderId integer,
  foreign key(productId) references tb_product(productId),
  foreign key(orderId) references tb_order(orderId)
);


StringBuilder stringBuilder = new StringBuilder();
		stringBuilder
				.append("create table tb_product(                                   ");
		stringBuilder
				.append("  productId integer primary key autoincrement,             ");
		stringBuilder
				.append("  name varchar(50) not null,                               ");
		stringBuilder
				.append("  price numeric(5,2) not null                              ");
		stringBuilder
				.append(");                                                         ");
		stringBuilder
				.append("                                                           ");
		stringBuilder
				.append("create table tb_user(                                      ");
		stringBuilder
				.append("  userId integer primary key autoincrement,                ");
		stringBuilder
				.append("  name varchar(50) not null                                ");
		stringBuilder
				.append(");                                                         ");
		stringBuilder
				.append("                                                           ");
		stringBuilder
				.append("create table tb_order(                                     ");
		stringBuilder
				.append("  orderId integer primary key autoincrement,               ");
		stringBuilder
				.append("  orderTotalPrice numeric(10,2) not null,                  ");
		stringBuilder
				.append("  userId integer,                                          ");
		stringBuilder
				.append("  foreign key(userId) references tb_user(userId)           ");
		stringBuilder
				.append(");                                                         ");
		stringBuilder
				.append("                                                           ");
		stringBuilder
				.append("create table tb_orderitem(                                 ");
		stringBuilder
				.append("  orderItemId integer primary key autoincrement,           ");
		stringBuilder
				.append("  productId integer,                                       ");
		stringBuilder
				.append("  amount integer,                                          ");
		stringBuilder
				.append("  orderItemPrice numeric(8,2) not null,                    ");
		stringBuilder
				.append("  orderId integer,                                         ");
		stringBuilder
				.append("  foreign key(productId) references tb_product(productId), ");
		stringBuilder
				.append("  foreign key(orderId) references tb_order(orderId)        ");
		stringBuilder
				.append(");                                                         ");

		db.execSQL(stringBuilder.toString());







