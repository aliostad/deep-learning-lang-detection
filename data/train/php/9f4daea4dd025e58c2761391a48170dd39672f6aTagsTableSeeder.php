<?php

class TagsTableSeeder extends Seeder {

	public function run()
	{
		DB::table('tags')->delete();

            $tag = new Tag();
            $tag->name = "antiques";
            $tag->save();

            $tag = new Tag();
            $tag->name = "appliances";
            $tag->save();

            $tag = new Tag();
            $tag->name = "art";
            $tag->save();

            $tag = new Tag();
            $tag->name = "art supplies";
            $tag->save();

            $tag = new Tag();
            $tag->name = "baby";
            $tag->save();

            $tag = new Tag();
            $tag->name = "books";
            $tag->save();

            $tag = new Tag();
            $tag->name = "children's clothing";
            $tag->save();

            $tag = new Tag();
            $tag->name = "collectibles";
            $tag->save();

            $tag = new Tag();
            $tag->name = "electronics";
            $tag->save();

            $tag = new Tag();
            $tag->name = "entertainment";
            $tag->save();

            $tag = new Tag();
            $tag->name = "furniture";
            $tag->save();

            $tag = new Tag();
            $tag->name = "gardening";
            $tag->save();

            $tag = new Tag();
            $tag->name = "glassware";
            $tag->save();

            $tag = new Tag();
            $tag->name = "health & beauty";
            $tag->save();

            $tag = new Tag();
            $tag->name = "home decor";
            $tag->save();

            $tag = new Tag();
            $tag->name = "home improvement";
            $tag->save();

            $tag = new Tag();
            $tag->name = "household items";
            $tag->save();

            $tag = new Tag();
            $tag->name = "jewelry";
            $tag->save();

            $tag = new Tag();
            $tag->name = "kitchen";
            $tag->save();

            $tag = new Tag();
            $tag->name = "men's clothing";
            $tag->save();

            $tag = new Tag();
            $tag->name = "musical instruments";
            $tag->save();

            $tag = new Tag();
            $tag->name = "sporting goods";
            $tag->save();

            $tag = new Tag();
            $tag->name = "toys";
            $tag->save();

            $tag = new Tag();
            $tag->name = "women's clothing";
            $tag->save();
	}

}