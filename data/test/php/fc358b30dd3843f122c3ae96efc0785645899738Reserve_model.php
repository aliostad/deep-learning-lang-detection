<?php

class Reserve_model extends CI_Model {

	function __construct() {
		parent::__construct();
	}

	function is_reserved( $copy ) {
		$this->db->select( 'status' );
		$this->db->from( 'copy' );
		$this->db->where( 'id', $copy );
		$query = $this->db->get();
		$resultArray = $query->result_array();
		foreach( $resultArray as $result ) {
			if( $result['status'] == 'R' ) {
				return TRUE;
			} else {
				return FALSE;
			}
		}
	}

	function reserved_by( $copy ) {
		$this->db->select( 'user' );
		$this->db->from( 'reservation' );
		$this->db->where( array('copy'=>$copy, 'issued'=>0) );
	}

	function reserve( $copy ) {
		$this->db->where( 'id', $copy );
		$this->db->update( 'copy', array('status'=>'R') );
	}

	function unreserve( $copy ) {
		$this->db->where( 'id', $copy );
		$this->db->update( 'copy', array('status'=>'A') );
	}

	function add( $user, $copy ) {
		$inputs = array( 'user'=>$user, 'copy'=>$copy, 'issued'=>0 );
		$this->db->insert( 'reservation', $inputs );
	}
}