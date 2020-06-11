<?php

class Databases_Tables_LogsApi extends Zend_Db_Table
{
    protected $_name = 'logs_api';
    var $contents; //array
    var $api_target;
    var $api_type;
    var $api_status; //0=Pending, 1=Finished
    var $api_step=1; //1=Send, 2=Receive
    var $logs_api_id;
    var $api_response;
    
    
    function InsertLog()
    {
        $data = array(
            "contents" => Zend_Json::encode($this->contents),
            "api_target" => $this->api_target,
            "api_type" => $this->api_type,
            "api_status" => $this->api_status,
            "api_step" => $this->api_step,
            "issue_time" => date("Y-m-d H:i:s")
        );
        
        $logs_api_id = $this->insert($data);
        
        return $logs_api_id;
    }
    
    function UpdateLog()
    {
        $result = FALSE;
        
        if($this->logs_api_id)
        {
            $row = $this->fetchRow("logs_api_id = '".$this->logs_api_id."'");
            $row->api_status = $this->api_status;
            $row->api_response = $this->api_response;
            if($row->save())
            {
                $result = TRUE;
            }
        }
        
        return $result;
    }
}