<?php

use Illuminate\Database\Seeder;
use App\Taste;

class tasteTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $tast = new Taste;
        $tast->tastes = "bitter";
        $tast->save();

        $tast1 = new Taste;
        $tast1->tastes = "zoet";
        $tast1->save();

        $tast2 = new Taste;
        $tast2->tastes = "zout";
        $tast2->save();

        $tast3 = new Taste;
        $tast3->tastes = "zuur";
        $tast3->save();

        $tast4 = new Taste;
        $tast4->tastes = "umami";
        $tast4->save();

        $tast5 = new Taste;
        $tast5->tastes = "chinees";
        $tast5->save();

        $tast5 = new Taste;
        $tast5->tastes = "italiaans";
        $tast5->save();

        $tast5 = new Taste;
        $tast5->tastes = "italiaans";
        $tast5->save();

        $tast5 = new Taste;
        $tast5->tastes = "vegitarisch";
        $tast5->save();

        $tast5 = new Taste;
        $tast5->tastes = "boerenkost";
        $tast5->save();

        $tast5 = new Taste;
        $tast5->tastes = "spaans";
        $tast5->save();
    }
}
