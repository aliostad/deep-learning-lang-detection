<?php

use Illuminate\Database\Seeder;
use Illuminate\Database\Eloquent\Model;
use App\UserServiceBucket;
 

 
    class UserServiceBucketTableSeeder extends Seeder {

    public function run()
    {		UserServiceBucket::truncate();
				UserServiceBucket::create(['user_id' => '1',
        			'service_id' => '1',
              'service_remaining' => '4',
       				'total_service' => '4']);
        UserServiceBucket::create(['user_id' => '2',
              'service_id' => '2',
              'service_remaining' => '4',
              'total_service' => '7']);
        UserServiceBucket::create(['user_id' => '3',
              'service_id' => '3',
              'service_remaining' => '7',
              'total_service' => '14']);
        UserServiceBucket::create(['user_id' => '4',
              'service_id' => '4',
              'service_remaining' => '32',
              'total_service' => '42']);
        UserServiceBucket::create(['user_id' => '5',
              'service_id' => '5',
              'service_remaining' => '12',
              'total_service' => '23']);
      }
}