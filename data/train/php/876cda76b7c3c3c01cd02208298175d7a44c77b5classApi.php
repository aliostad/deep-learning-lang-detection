<?php
class Api{
    protected $api_key;
    
    function __construct(){
        @$this->api_key = intval($_GET['api_key']);
    }
    
    
    /*
     * Проверяем, существует ли клиентский API, 
     * который постоянно передаётся с запросом.
     * В противном случае - exit
     */
    public function validate_api_key(){
        if (!$this->api_key) Core::error_msg('Не указан ключ API');
        
        $query = "SELECT id "
                    . "FROM ss_users "
                    . "WHERE api_key=".$this->api_key;
        
        $result = mysql_query($query);
        
        $otvet_api = mysql_num_rows($result);            
        
        if ($otvet_api !== 1) Core::error_msg('Заданого API ключа не существует');
    }
    

}
