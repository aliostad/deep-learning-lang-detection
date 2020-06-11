<?php

class AdminController extends BaseController {

	public function home() {
		// $config = ConfigData::find(1);
		// // get current show, previous show, and next show
		// // first see if a show is being scored
		// $show = Show::where('showstatus','=',1)->get();
		// Debugbar::info($show);
		// if (!isset($show[0])) {
		// 	// current will be the first open show
		// 	$show = Show::where('showstatus','=',0)->orderBy('setdate')->get();
		// 	Debugbar::info("first open show",
		// 	Debugbar::info($show[0]));
		// 	if (!isset($show[0])) {
		// 		// next to last show
		// 		$nextshow = Show::orderBy('setdate','asc')->first();
		// 		$show = Show::where('setdate','<',$nextshow->setdate)->get();
		// 		$prevshow = Show::where('setdate','<',$show[0]->setdate)->get();
		// 	}
		// 	else {
		// 		$nextshow = Show::where('setdate','>',$show[0]->setdate)->orderBy('setdate','asc')->get();
		// 		$prevshow = Show::where('setdate','<',$show[0]->setdate)->orderBy('setdate','desc')->get();	
		// 	}
		// }
		// else {
		// 		$nextshow = Show::where('setdate','>',$show[0]->setdate)->orderBy('setdate','asc')->get();
		// 		$prevshow = Show::where('setdate','<',$show[0]->setdate)->orderBy('setdate','desc')->get();	
		// }

		$shows = Show::getShows();
		// $venue = $shows[2]->venue()->name;
		Debugbar::info($shows[0]);
		// return View::make('success');
		return View::make('admin.home',array(
				'prevshow' => $shows[0],
				'curshow' => $shows[1],
				'nextshow' => $shows[2]
				
			));

	}
}