<?php

class CopyController extends BaseController {
	
	protected $layout = 'layouts.admin';

	public function showCopy($page) {		
		$content = DB::table('copy')->where('name', $page)->pluck('content');
		$this->layout->content = View::make('admin.copy', compact('content', 'page'));
	}

	public function postCopy($page) {
		$content = Input::get('content');
		DB::table('copy')->where('name', $page)->update(array('content' => $content));
		return Redirect::route('admin.copy', $page)->with('updated', 'Updated');
	}	

}