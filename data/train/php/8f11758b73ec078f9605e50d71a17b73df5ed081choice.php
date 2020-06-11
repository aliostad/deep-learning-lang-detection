<?php

class Choice_Task{

	public function run($args){
		// Goals
		$x = new Goal(array('name'=>'Lose weight'));
		$x->save();

		$x = new Goal(array('name'=>'Maintain weight'));
		$x->save();

		$x = new Goal(array('name'=>'Gain weight'));
		$x->save();

		$x = new Goal(array('name'=>'Improve body measurements'));
		$x->save();

		$x = new Goal(array('name'=>'Reduce body fat percentage'));
		$x->save();

		$x = new Goal(array('name'=>'Increase strength'));
		$x->save();

		$x = new Goal(array('name'=>'Increase endurance'));
		$x->save();

		$x = new Goal(array('name'=>'Life goals (Quit smoking, get more sleep, etc)'));
		$x->save();

		$x = new Goal(array('name'=>'I don\'t know yet'));
		$x->save();

		$x = new Goal(array('name'=>'I don\'t have any goals'));
		$x->save();

		$x = new Goal(array('name'=>'I prefer not to say'));
		$x->save();

		$x = new Goal(array('name'=>'Other'));
		$x->save();

		// Diets

		$x = new Diet(array('name'=>'Vegetarian'));
		$x->save();

		$x = new Diet(array('name'=>'Vegan'));
		$x->save();

		$x = new Diet(array('name'=>'Keto'));
		$x->save();

		$x = new Diet(array('name'=>'Paleo'));
		$x->save();

		$x = new Diet(array('name'=>'Low-carb'));
		$x->save();

		$x = new Diet(array('name'=>'Small ( <500 ) calorie deficit'));
		$x->save();

		$x = new Diet(array('name'=>'Large calorie deficit'));
		$x->save();

		$x = new Diet(array('name'=>'Intermittent fasting'));
		$x->save();

		$x = new Diet(array('name'=>'"Clean" eating'));
		$x->save();

		$x = new Diet(array('name'=>'High protein'));
		$x->save();

		$x = new Diet(array('name'=>'Low fat'));
		$x->save();

		$x = new Diet(array('name'=>'Low sodium'));
		$x->save();

		$x = new Diet(array('name'=>'Weight Watchers'));
		$x->save();

		$x = new Diet(array('name'=>'Jenny Craig'));
		$x->save();

		$x = new Diet(array('name'=>'I will not be following any specific diet'));
		$x->save();

		$x = new Diet(array('name'=>'I don\'t know yet'));
		$x->save();

		$x = new Diet(array('name'=>'I prefer not to say'));
		$x->save();

		$x = new Diet(array('name'=>'Other'));
		$x->save();

		// Exercise types

		$x = new Exercise_Type(array('name'=>'Powerlifting'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Olympic lifting'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'General weightlifting'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Bodyweight exercises'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Circuit training'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Running / Jogging'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Aerobics'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Walking'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Swimming'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Rock climbing'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Biking'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Yoga'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Zumba'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Crossfit'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'P90X'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Power 90'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Sports'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'I\'m not going to exercise'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'I don\'t know yet'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'I prefer not to say'));
		$x->save();

		$x = new Exercise_Type(array('name'=>'Other'));
		$x->save();

		// Fitness Trackers

		$x = new Fitness_Tracker(array('name'=>'Fitocracy'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'MyFitnessPal'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'LiveStrong'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'FitDay'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'SparkPeople'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'loseit.com'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'Personal Spreadsheet'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'Pen & Paper'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'I don\'t know yet'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'I will not be tracking my food or exercise.'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'I prefer not to say'));
		$x->save();

		$x = new Fitness_Tracker(array('name'=>'Other'));
		$x->save();


	}
}

?>