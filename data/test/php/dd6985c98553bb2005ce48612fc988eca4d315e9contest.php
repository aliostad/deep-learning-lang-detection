<?php
class ContestContests_Model_Contest {
	
	function findAll() {
		global $wpdb;
		$tableName = $wpdb->prefix . "contests";
		$items = $wpdb->get_results("SELECT * FROM $tableName ORDER BY id DESC");
		return $items;
	}
	
	function find($id) {
		global $wpdb;
		$tableName = $wpdb->prefix . "contests";
		$items = $wpdb->get_results("SELECT * FROM $tableName WHERE id = $id LIMIT 1");
		return end($items);
	}
	
	function getContestUsers($contestId) {
		global $wpdb;
		$tableName = $wpdb->prefix . "contest_users";
		$items = $wpdb->get_results("SELECT * FROM $tableName WHERE contest_id = $contestId");
		return $items;
	}
	
	function countContestUsers($contestId) {
		global $wpdb;
		$tableName = $wpdb->prefix . "contest_users";
		$items = $wpdb->get_results("SELECT COUNT(*) as c FROM $tableName WHERE contest_id = $contestId");
		return end($items)->c;
	}
	
	function create($params) {		
		global $wpdb;
		$tableName = $wpdb->prefix . "contests";
		
		$name = $wpdb->escape($params["name"]);
		$description = $wpdb->escape($params["description"]);
		$showName = !is_null($params["show_name"]) ? $wpdb->escape($params["show_name"]) : 0;
		$showEmail = !is_null($params["show_email"]) ? $wpdb->escape($params["show_email"]) : 0;
		$showAddress1 = !is_null($params["show_address1"]) ? $wpdb->escape($params["show_address1"]) : 0;
		$showAddress2 = !is_null($params["show_address2"]) ? $wpdb->escape($params["show_address2"]) : 0;
		$showAddress3 = !is_null($params["show_address3"]) ? $wpdb->escape($params["show_address3"]) : 0;
		$showAddress4 = !is_null($params["show_address4"]) ? $wpdb->escape($params["show_address4"]) : 0;
		$showZipcode = !is_null($params["show_zipcode"]) ? $wpdb->escape($params["show_zipcode"]) : 0;
		$showCity = !is_null($params["show_city"]) ? $wpdb->escape($params["show_city"]) : 0;
		$showState = !is_null($params["show_state"]) ? $wpdb->escape($params["show_state"]) : 0;
		$showDocument = !is_null($params["show_document"]) ? $wpdb->escape($params["show_document"]) : 0;
		$showBirthday = !is_null($params["show_birthday"]) ? $wpdb->escape($params["show_birthday"]) : 0;
		$showAnswer = !is_null($params["show_answer"]) ? $wpdb->escape($params["show_answer"]) : 0;
		$createdAt = date("Y-m-d"); 
		
		$wpdb->query(" INSERT INTO $tableName (name, description, show_name, show_email, show_address1, show_address2, show_address3, show_address4, show_zipcode, show_city, show_state, show_document, show_birthday, show_answer, created_at) VALUES ('$name', '$description', $showName, $showEmail, $showAddress1, $showAddress2, $showAddress3, $showAddress4, $showZipcode, $showCity, $showState, $showDocument, $showBirthday, $showAnswer, '$createdAt') ");
	}
	
	function getLast() {
		global $wpdb;
		$tableName = $wpdb->prefix . "contests";
		$items = $wpdb->get_results("SELECT * FROM $tableName ORDER BY id DESC LIMIT 1");
		return end($items);
	}
	
	function update($id, $params) {		
		global $wpdb;
		$tableName = $wpdb->prefix . "contests";		
		
		$name = $wpdb->escape($params["name"]);
		$description = $wpdb->escape($params["description"]);
		$showName = !is_null($params["show_name"]) ? $wpdb->escape($params["show_name"]) : 0;
		$showEmail = !is_null($params["show_email"]) ? $wpdb->escape($params["show_email"]) : 0;
		$showAddress1 = !is_null($params["show_address1"]) ? $wpdb->escape($params["show_address1"]) : 0;
		$showAddress2 = !is_null($params["show_address2"]) ? $wpdb->escape($params["show_address2"]) : 0;
		$showAddress3 = !is_null($params["show_address3"]) ? $wpdb->escape($params["show_address3"]) : 0;
		$showAddress4 = !is_null($params["show_address4"]) ? $wpdb->escape($params["show_address4"]) : 0;
		$showZipcode = !is_null($params["show_zipcode"]) ? $wpdb->escape($params["show_zipcode"]) : 0;
		$showCity = !is_null($params["show_city"]) ? $wpdb->escape($params["show_city"]) : 0;
		$showState = !is_null($params["show_state"]) ? $wpdb->escape($params["show_state"]) : 0;
		$showDocument = !is_null($params["show_document"]) ? $wpdb->escape($params["show_document"]) : 0;
		$showBirthday = !is_null($params["show_birthday"]) ? $wpdb->escape($params["show_birthday"]) : 0;
		$showAnswer = !is_null($params["show_answer"]) ? $wpdb->escape($params["show_answer"]) : 0;
		
		$wpdb->query(" UPDATE $tableName SET name = '$name', description = '$description', show_name = $showName, show_email = $showEmail, show_address1 = $showAddress1, show_address2 = $showAddress2, show_address3 = $showAddress3, show_address4 = $showAddress4, show_zipcode = $showZipcode, show_city = $showCity, show_state = $showState, show_document = $showDocument, show_birthday = $showBirthday, show_answer = $showAnswer WHERE id = $id ");
	}
	
	function delete($id) {		
		global $wpdb;
		$tableName = $wpdb->prefix . "contests";		
		$wpdb->query(" DELETE FROM $tableName WHERE id = $id ");
		$tableName = $wpdb->prefix . "contest_users";
		$wpdb->query(" DELETE FROM $tableName WHERE contest_id = $id ");
	}
}
?>