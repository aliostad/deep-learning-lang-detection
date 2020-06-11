<?php 
namespace Universal\Session\SaveHandler;

class RedisSaveHandler
{
    /*
    ini_set('session.save_path',
        "tcp://host1:6379?weight=1, tcp://host2:6379?weight=2&timeout=2.5, tcp://host3:6379?weight=2");
    */
    public function __construct($savePath = null)
    {
        ini_set('session.save_handler', 'redis');

        // default savePath
        if( ! $savePath )
            $savePath = 'tcp://127.0.0.1:6379';
        ini_set('session.save_path', is_array($savePath) ? join(',',$savePath) : $savePath );
    }
}
