insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
null,
'/',
'Home',
'Home Page',
0
);

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
null,
'/bikes.php',
'Bikes',
'Bikes We Sell',
0
);

set @bikesId = last_insert_id();

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
null,
'/aboutus.php',
'About Us',
'About Single Track',
0
);

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
null,
'/location.php',
'Location and Contact Info',
'Single Track\'s Location and Contact Info',
0
);

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
@bikesId,
'/bikes.php',
'Bike Brands',
null,
0
);

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
@bikesId,
'/product.php?product_id=3',
'Parts',
'Bike Parts We Sell',
0
);

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
@bikesId,
'/product.php?product_id=4',
'Gear',
'Gear We Sell',
0
);

/*
insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
@bikesId,
'/product.php?product_id=3',
'Trek',
'Trek Bikes',
0
);

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
@bikesId,
'/product.php?product_id=4',
'Surly',
'Surly Bikes and Frames',
0
);

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
@bikesId,
'/product.php',
'Parts',
'Bike Parts We Sell',
0
);

insert into single_track.nav_links
(parent_nav_link_id, link_url, link_text, link_hover_text, editable)
values (
@bikesId,
'/product.php',
'Gear',
'Gear We Sell',
0
);

*/
