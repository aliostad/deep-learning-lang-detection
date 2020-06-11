<?php

class CategoriesTableSeeder extends Seeder {
    
    public function run() {
        $category = new category;
        $category->name = 'Art';
        $category->save();

        $category = new category;
        $category->name = 'Jewlry';
        $category->save();

        $category = new category;
        $category->name = 'Accessories';
        $category->save();

        $category = new category;
        $category->name = 'Gadgets';
        $category->save();

        $category = new category;
        $category->name = 'Miniatures';
        $category->save();

        $category = new category;
        $category->name = 'Custom';
        $category->save();
    }
}