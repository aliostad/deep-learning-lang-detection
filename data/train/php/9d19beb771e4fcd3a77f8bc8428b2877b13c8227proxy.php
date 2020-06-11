<?php 
require_once dirname(__FILE__) . "/proxy-handler.php";

class Proxy
{
    public $handler_array = array();

    public function add_handler($handler_name, ProxyHandler $handler)
    {
        $this->handler_array[$handler_name] = $handler;
    }

    public function remove_handler($handler_name)
    {
        unset($this->handler_array[$handler_name]);
    }

    public function remove_all()
    {
        foreach ($this->handler_array as $handler_name)
        {
            unset($this->handler_array[$handler_name]);
        } 
    }

    public function before_working($param = null)
    {
        foreach ($this->handler_array as $handler)
        {
            $handler->before_working($param);
        }
    }

    public function after_working($param = null)
    {
        foreach ($this->handler_array as $handler)
        {
            $handler->after_working($param);
        }
    }
}
?>
