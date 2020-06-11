<?php

require_once("php/class.apifactory.php");
require_once("php/class.cache.php");

$api = new APIFactory();
$api->add_hooker('AF_Cache');
$api->fromJSON("./apis/mobicart.json");

$api->api_key = 1234;
$api->user_name = 'richthegeek@gmail.com';

print_r(
// $api->articles()
// $api->articles->count()
// $api->articles->show(1219922, 4069342)
// $api->articles->create(1219922, 'Lorum ipsum dolor sit amet', 'Richard Lyon', 'Welcome to the jungle')
// $api->articles->update(array('blog_ig' => 1219922, 'id' => 4070562, 'title' => 'Bonjour ou la copse'))
// $api->articles->delete(121992, 4070562)

// $api->assets(1867362)
// $api->assets->get(1867362, 'templates/ign.liquid')
// $api->assets->save(array("theme_id" => 1867362, "key" => "templates/ign.liquid", "value" => "Ignore me"))
// $api->assets->delete(1867362, "templates/ign.liquid")

// $api->blogs()
// $api->blogs->count()
// $api->blogs->get(1219922)
// $api->blogs->create("My new blog")
// $api->blogs->update(array("id" => 1220232, "title" => "My blog"))
// $api->blogs->delete(1220232)

// $api->collections()
// $api->collections->count(4877562)
// $api->collections->count(4877562,54655002)
// $api->collections->get(4877562)
// $api->collections->create(54655002, 4877562)
// $api->collections->delete(4877562)

// $api->comments->count()
// $api->comments->get()
// $api->comments->update(12345)

# CANNOT GET THESE TO WORK
// $api->comments->create("My comment is super cool and made of win and similar exotic materia", "Richard Lyon", 1219922, "4069342-first-post", "php_penguin@hotmail.com")
// $api->comments(array('blog_id'=>1219922, 'article_id'=>4069342))
# AND SO CANNOT TEST THESE
// $api->comments->update(id, ...)
// $api->comments->spam(id)
// $api->comments->not_spam(id)
// $api->comments->approve($id)
// $api->comments->delete($id)

// $api->countries()
// $api->countries->count()
// $api->countries->create('GB')
// $api->countries->update(array('id' => 2959782, 'tax' => '0.2'))
// $api->countries->delete(2959782)

// $api->custom_collections()
// $api->custom_collections->count()
// $api->custom_collections->get(4877562)
// $api->custom_collections->create('Socks')
// $api->custom_collections->update(array('id' => 4887032, 'published' => 0))
// $api->custom_collections->delete(4887032)

// $api->customers()
// $api->customers->search(false, false, false, 'Leland', array('country' => 'United States'))
// $api->customers->get(56900472)
// $api->customers->create(array('first_name' => 'Richard', 'last_name' => 'Lyon', 'email' => 'bob@gmail.com'))
// $api->customers->update(array('id' => '57975392', 'first_name' => 'Richard', 'last_name' => 'Lyon', 'note' => 'Not a real customer'))
// $api->customers->delete(57975392)

// $api->customer_groups()
// $api->customer_groups->get(4584172)
// $api->customer_groups->customers(4584172)
// $api->customer_groups->create('No Orders', 'orders_count:0')
// $api->customer_groups->update(4620022, 'Zero Orders')
// $api->customer_groups->delete(4620022)

$api->metafields()

// $api->themes()
// $api->themes->get(1867362)
// $api->themes->create("Lemongrass", "main", "http://dl.dropbox.com/u/195599/trig.zip")
// $api->themes->update(1867612, "Trig", "main")
// $api->themes->delete(1867612)

// $api->shop()

);