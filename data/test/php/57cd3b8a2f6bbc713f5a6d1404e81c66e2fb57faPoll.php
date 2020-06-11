<?php

class Poll extends Eloquent
{
	public function trip1(){
		return $this->belongsToMany("Trip", "trip1", "id");
	}

	public function trip2(){
		return $this->belongsToMany("Trip", "trip2", "id");
	}

	public function trip3(){
		return $this->belongsToMany("Trip", "trip3", "id");
	}

	public function trip4(){
		return $this->belongsToMany("Trip", "trip4", "id");
	}

	public function trip5(){
		return $this->belongsToMany("Trip", "trip5", "id");
	}

	public function scopeSelectOpts(){
		$selectVals[''] = "Please Select";
		$selectVals += $this->lists("id", "id");
		return $selectVals;
	}

	public function scopeDisplay(){
		$showVals = "<h3>The current polls are</h3>\n";
		$showVals = $showVals."<table>";
			$showVals = $showVals."<tr>\n\t<td>Poll ID# </td>\n";
			$showVals = $showVals."\t<td>Trip 1 </td>\n";
			$showVals = $showVals."\t<td>Tally </td>\n";
			$showVals = $showVals."\t<td>Trip 2 </td>\n";
			$showVals = $showVals."\t<td>Tally </td>\n";
			$showVals = $showVals."\t<td>Trip 3 </td>\n";
			$showVals = $showVals."\t<td>Tally </td>\n";
			$showVals = $showVals."\t<td>Trip 4 </td>\n";
			$showVals = $showVals."\t<td>Tally </td>\n";
			$showVals = $showVals."\t<td>Trip 5 </td>\n";
			$showVals = $showVals."\t<td>Tally </td>\n</tr>";
		foreach($this->with("trips")->get() as $poll){
			$showVals = $showVals."<tr>\n\t<td>Poll #: ".$poll->id."</td>\n";
			$showVals = $showVals."\t<td>Trip 1: ".$poll->trip1."</td>\n";
			$showVals = $showVals."\t<td>Tally : ".$poll->tally1."</td>\n";
			$showVals = $showVals."\t<td>Trip 2: ".$poll->trip2."</td>\n";
			$showVals = $showVals."\t<td>Tally : ".$poll->tally2."</td>\n";
			$showVals = $showVals."\t<td>Trip 3: ".$poll->trip3."</td>\n";
			$showVals = $showVals."\t<td>Tally : ".$poll->tally3."</td>\n";
			$showVals = $showVals."\t<td>Trip 4: ".$poll->trip4."</td>\n";
			$showVals = $showVals."\t<td>Tally : ".$poll->tally4."</td>\n";
			$showVals = $showVals."\t<td>Trip 5: ".$poll->trip5."</td>\n";
			$showVals = $showVals."\t<td>Tally : ".$poll->tally5."</td>\n</tr>";
		}
		$showVals = $showVals."</table>";
		return $showVals;
	}

}