<?php

class CategoriesTableSeeder extends Seeder 
{

	public function run()
	{
		$category = new Category();
		$category->category = 'Animals';
		$category->save();

		$category = new Category();
		$category->category = 'Children';
		$category->save();

		$category = new Category();
		$category->category = 'Community';
		$category->save();

		$category = new Category();
		$category->category = 'Disaster Relief';
		$category->save();

		$category = new Category();
		$category->category = 'Environment';
		$category->save();

		$category = new Category();
		$category->category = 'Homelessness';
		$category->save();

		$category = new Category();
		$category->category = 'Hunger';
		$category->save();

		$category = new Category();
		$category->category = 'Housing';
		$category->save();

		$category = new Category();
		$category->category = 'Veterans';
		$category->save();
	}
}

