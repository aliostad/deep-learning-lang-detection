<?php

use aCube\Entities\CategoryApiRoutePerm;

class CategoryApiRoutePermsTableSeeder extends Seeder {

	public function run()
	{
		$categoryApiRoutePerms = array(
				array(
					'api_route_id' => 1,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 2,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 3,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 4,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 5,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 6,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 7,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 8,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 9,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 10,
					'category_id'  => 1,					
				),
				array(
					'api_route_id' => 11,
					'category_id'  => 1,					
				),
			);

		foreach($categoryApiRoutePerms as $categoryApiRoutePerm)
		{
			CategoryApiRoutePerm::create($categoryApiRoutePerm);
		}
	}

}