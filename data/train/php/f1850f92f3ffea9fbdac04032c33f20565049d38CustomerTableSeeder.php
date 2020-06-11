<?php

use Illuminate\Database\Seeder;
use App\Customer;

class CustomerTableSeeder extends Seeder
{
  public function run()
  {
    $this->command->info('Seeding customers...');

    $accountData = DB::table('movedb.customer')->get();

    Eloquent::unguard();
    foreach ($accountData as $accountSingle) {
      Customer::create([
        'id' => $accountSingle->customer_seq_no,
        'customer_last_name' => $accountSingle->customer_last_name,
        'customer_first_name' => $accountSingle->customer_first_name,
        'customer_address' => $accountSingle->customer_address,
        'customer_city' => $accountSingle->customer_city,
        'customer_state' => $accountSingle->customer_state,
        'customer_zip' => $accountSingle->customer_zip,
        'customer_home_phone' => $accountSingle->customer_home_phone,
        'customer_work_phone' => $accountSingle->customer_work_phone,
        'customer_email' => $accountSingle->customer_email,
        'customer_emergency_contact' => $accountSingle->customer_emergency_contact,
        'customer_emergency_phone' => $accountSingle->customer_emergency_phone,
        'customer_comments' => $accountSingle->customer_comments,
        'customer_pager' => $accountSingle->customer_pager,
        'customer_cell' => $accountSingle->customer_cell,
      ]);

    }
  }

}
