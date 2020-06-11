<?php
 
class Display_handler extends CI_Model {
	/*
		Responsible for fetching data from database.
	*/
	public function get_all_shows(){
		$this->load->model('show_dal');
    	$shows = $this->show_dal->get_all_shows();
    	return $shows;
	}
	public function get_five_shows(){
		$this->load->model('show_dal');
    	$shows = $this->show_dal->get_five_shows();
    	return $shows;
	}
	public function get_all_persons(){
		$this->load->model('show_dal');
    	$persons = $this->show_dal->get_all_persons();
    	return $persons;
	}
	public function get_five_persons(){
		$this->load->model('show_dal');
    	$shows = $this->show_dal->get_five_persons();
    	return $shows;
	}
	public function get_person_by_ID($personID){
		$this->load->model('show_dal');
    	$person = $this->show_dal->get_person_by_ID($personID);
    	return $person;
	}
	public function get_show_by_ID($showID){
		$this->load->model('show_dal');
    	$show = $this->show_dal->get_show_by_ID($showID);
    	return $show;
	}
	public function get_crew_by_showID($showID){
		$this->load->model('show_dal');
		$crew = $this->show_dal->get_crew_by_showID($showID);
		return $crew;
	}
	public function get_cast_by_showID($showID){
		$this->load->model('show_dal');
		$cast = $this->show_dal->get_cast_by_showID($showID);
		return $cast;
	}
	public function get_shows_by_personID($personID){
		$this->load->model('show_dal');
    	$show = $this->show_dal->get_shows_by_personID($personID);
    	return $show;
	}
	public function get_acting_jobs($personID){
		$this->load->model('show_dal');
		$shows = $this->show_dal->get_acting_jobs($personID);
    	return $shows;
	}
	public function get_crew_jobs($personID){
		$this->load->model('show_dal');
		$shows = $this->show_dal->get_crew_jobs($personID);
    	return $shows;
	}
	public function get_cast_member_by_ID($cast_memberID){
		$this->load->model('show_dal');
		$cast_member = $this->show_dal->get_cast_member_by_ID($cast_memberID);
		return $cast_member;
	}
}
/* End of file display_handler.php */
/* Location: ./application/models/display_handler.php */