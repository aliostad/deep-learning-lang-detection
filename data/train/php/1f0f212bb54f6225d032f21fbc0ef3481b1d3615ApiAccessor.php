<?php

class Micro_Accessor_ApiAccessor
{
    private $_apis = array();

    public function __construct(array $apis)
    {
        foreach ($apis as $api) {
            // Generate api class name
            $api_elements = explode('_', $api);
            foreach ($api_elements as &$api_element) {
                $api_element = ucfirst($api_element);
            }
            $api_class = implode('_', $api_elements);

            // Load api class
            $api_file = Micro::$app_root_dir . '/api/' . str_replace('_', '/', $api_class) . '.php';
            if ( ! file_exists($api_file)) {
                $api_file = dirname(__FILE__). '/../Api/' . str_replace('_', '/', $api_class) . '.php';
                if ( ! file_exists($api_file)) {
                    throw new Exception("## Error : $api_file not found.");
                }
                $api_class = 'Micro_Api_' . $api_class;
            }
            require_once($api_file);

            $this->_apis[$api] = new $api_class;
        }
    }

    public function __get($name)
    {
        return $this->_apis[$name];
    }

}