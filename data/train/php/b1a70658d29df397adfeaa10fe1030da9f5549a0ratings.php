<?php

if (!defined('BASEPATH'))
    die();

class Ratings extends MY_Controller {

    public function __construct() {
        parent::__construct();
    }

    public function add_rating() {
        $show_id = $this->input->post('show_id');
        $user_id = $this->input->post('user_id');
        $rating = $this->input->post('score');
        $this->load->model('mrating_show');
        $check = $this->mrating_show->check_rating_exists($show_id, $user_id);
        if ($check) {
            echo "You have already rated";
        } else {
            $insert_id = $this->mrating_show->add_rating($show_id, $user_id, $rating);

            $rating = $this->mrating_show->get_rating($show_id);
            echo $rating[0]->rating;
        }
    }

    public function get_rating() {
        $this->load->model('mrating_show');
        $show_id = $this->input->post('show_id');
        $rating = $this->mrating_show->get_rating($show_id);
        echo $rating[0]->rating;
    }

}

?>
