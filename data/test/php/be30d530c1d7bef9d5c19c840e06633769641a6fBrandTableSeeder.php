<?php
/**
 * Created by PhpStorm.
 * User: Hp 840 G1
 * Date: 8/27/2015
 * Time: 1:54 PM
 */

class BrandTableSeeder extends Seeder{

    public function run() {
        DB::table('brands')->truncate();

        $brand = new Brand();
        $brand->name = "5TheWay";
        $brand->save();

        $brand = new Brand();
        $brand->name = "Nike";
        $brand->save();

        $brand = new Brand();
        $brand->name = "Adidas";
        $brand->save();

        $brand = new Brand();
        $brand->name = "Puma";
        $brand->save();

        $brand = new Brand();
        $brand->name = "Ripcurl";
        $brand->save();

        $brand = new Brand();
        $brand->name = "The Northface";
        $brand->save();

        $brand = new Brand();
        $brand->name = "Overdose";
        $brand->save();

        $brand = new Brand();
        $brand->name = "Kenstyle";
        $brand->save();

        $brand = new Brand();
        $brand->name = "Real Tree";
        $brand->save();

        $brand = new Brand();
        $brand->name = "Game Guard";
        $brand->save();
    }
} 