<?php

class StudentsController extends \BaseController {

	public function showMyClass() {
		$named_route = 'students.myClass';
		$named_route_token_array = explode('.', $named_route);
		//dd($named_route_token_array);
		return View::make('students.showMyClass')
			->with('named_route_token_array', $named_route_token_array);
	}

	public function showIndividually() {
		return View::make('students.showMyClass')->with('dummy', 'showIndividually');
	}

	public function showLevelTest() {
		return View::make('students.showMyClass')->with('dummy', 'showLevelTest');
	}

	public function participate() {
		return View::make('students.showMyClass')->with('dummy', 'participate');
	}

	public function showResults() {
		return View::make('students.showMyClass')->with('dummy', 'showResults');
	}

	public function showComprehensiveEvaluation() {
		return View::make('students.showMyClass')->with('dummy', 'showComprehensiveEvaluation');
	}

	public function showManageMyClass() {
		return View::make('students.showMyClass')->with('dummy', 'showManageMyClass');
	}

	public function showAbsenceManagement() {
		return View::make('students.showMyClass')->with('dummy', 'showAbsenceManagement');
	}

	public function showCommunity() {
		return View::make('students.showMyClass')->with('dummy', 'showCommunity');
	}

	public function showGuestBook() {
		return View::make('students.showMyClass')->with('dummy', 'showGuestBook');
	}

	public function showBoard() {
		return View::make('students.showMyClass')->with('dummy', 'showBoard');
	}

	public function showBulletin() {
		return View::make('students.showMyClass')->with('dummy', 'showBulletin');
	}

	public function showLearningMaterials() {
		return View::make('students.showMyClass')->with('dummy', 'showLearningMaterials');
	}

	public function showAssignment() {
		return View::make('students.showMyClass')->with('dummy', 'showAssignment');
	}

	public function showMySchedule() {
		return View::make('students.showMyClass')->with('dummy', 'showMySchedule');
	}

}