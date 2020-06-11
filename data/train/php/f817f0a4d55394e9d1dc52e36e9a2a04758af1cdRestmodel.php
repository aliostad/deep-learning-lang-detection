<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Restmodel extends CI_Model 
{
	function __construct()
	{
		$this->db = $this->load->database('default', TRUE);
	}

	function _is_public_api($p_api_id, $p_api_key, $p_api_secret)
    {
        $this->db->debug = 0;
        $sql = "SELECT
                    api_id
                FROM tm_api
                WHERE api_id = '" . $p_api_id . "'
                AND api_key = '" . $p_api_key . "' 
                AND api_secret = '" . $p_api_secret . "' 
                AND api_active = '1'
                AND api_deleted = '0'
                ";
        $rs = $this->db->query($sql);
        $rs = $rs->row_array();
        $data = array();
        if(isset($rs['api_id']))
        {
            $data['api_id'] = $rs['api_id'];
            return $data;
            unset($data);
        }
        else
        {
            return null;
        }
    }

    function update_last_connect($p_api_id, $p_api_key, $p_api_secret)
    {
        $this->db->debug = 0;
        $sql = "UPDATE tm_api
                    SET api_last_connect = now()
                WHERE api_id = '" . $p_api_id . "'
                     AND api_key = '" . $p_api_key . "' 
                     AND api_secret = '" . $p_api_secret . "' 
                ";
        $rs = $this->db->query($sql);
    }

    function insert_log_api_rest($p_api_id, $p_action, $log_status, $log_message, $ip, $parameter_sent)
    {
        $this->db->debug = 0;
        $sql = " INSERT INTO log_tm_api (tm_api_api_id, log_tm_api_activity, log_tm_api_parameter_sent, log_tm_api_status, log_tm_api_message, ip_address) 
                                        VALUES ('$p_api_id', '$p_action', '$parameter_sent', '$log_status', '$log_message', '$ip') ";
        $rs = $this->db->query($sql);
    }
}