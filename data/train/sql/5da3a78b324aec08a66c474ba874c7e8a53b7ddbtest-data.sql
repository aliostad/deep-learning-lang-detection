insert into banner (title, text, link, photo) values ('Iphone', 'Big big big', 'http://google.com', FILE_READ('classpath:images/carousel-ipad-air-2-buy-now.jpg'));
insert into banner (title, text, link, photo) values ('Ipad', 'Big big big 2', 'http://google.com', FILE_READ('classpath:images/1536x300.png'));
insert into banner (title, text, link, photo) values ('Samsung', 'Big big big 3', 'http://google.com', FILE_READ('classpath:images/carousel-ipad-air-2-buy-now.jpg'));
insert into banner (title, text, link, photo) values ('Blackberry', 'Big big big 4', 'http://google.com', FILE_READ('classpath:images/1536x300.png'));

insert into tab (title, text) values ('Existing Customer', '');
insert into tab (title, text) values ('New Customer', '');

insert into tab (title, text, parent_id, photo) values ('Store','View our latest phones or recontract', 1, FILE_READ('classpath:images/shop.png'));
insert into tab (title, text, parent_id, photo) values ('Promotions','See our latest deals', 1, FILE_READ('classpath:images/promotion.png'));
insert into tab (title, text, parent_id, photo) values ('Support','Get your solution here', 1, FILE_READ('classpath:images/support.png'));
insert into tab (title, text, parent_id, photo) values ('Hub iD Sign-in','Manage your account', 1, FILE_READ('classpath:images/sign-in.png'));

insert into tab (title, text, parent_id, photo) values ('Why StarHub','Learn about our services', 2, FILE_READ('classpath:images/why-starhub.png'));
insert into tab (title, text, parent_id, photo) values ('Mobile Plans','View our Postpaid Plans', 2, FILE_READ('classpath:images/mobile-plans.png'));
insert into tab (title, text, parent_id, photo) values ('Promotions','See our latest deals', 2, FILE_READ('classpath:images/promotion.png'));
insert into tab (title, text, parent_id, photo) values ('Home Hubbing','Bundle your services & save', 2, FILE_READ('classpath:images/hubbing.png'));
