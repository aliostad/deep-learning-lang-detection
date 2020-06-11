<?php

use Illuminate\Database\Seeder;

class TagSeeder extends Seeder
{
	/**
	 * Run the database seeds.
	 *
	 * @return void
	 */
	public function run()
	{
		// tag
		with(new \App\Tag(['tag' => 'adventure']))->save();
		with(new \App\Tag(['tag' => 'sports']))->save();

		// place
		with(new \App\Tag(['tag' => 'pemandangan']))->save();
		with(new \App\Tag(['tag' => 'belanja']))->save();
		with(new \App\Tag(['tag' => 'kesehatan']))->save();
		with(new \App\Tag(['tag' => 'budaya']))->save();
		with(new \App\Tag(['tag' => 'hiburan']))->save();
		with(new \App\Tag(['tag' => 'kuliner']))->save();
		with(new \App\Tag(['tag' => 'pantai']))->save();
		with(new \App\Tag(['tag' => 'gunung']))->save();
	}
}
