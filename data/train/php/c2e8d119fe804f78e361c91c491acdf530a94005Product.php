<?php
/**
 * Created by Farcek@gmail.com.
 * User: Farcek
 * Date: 10/30/11
 * Time: 9:07 PM
 */

namespace myLib;

/**
 * 
 * short desc
 *
 * ene logg dicription shuu
 * za yu
 *
 * 
 * @className parsing
 * @new line string
 *
 * @mattel (sunk="32",statis=343)
 * @zayu
 */
class Product extends \PhpCore\Object{
    var $name;
    var $code;


    var $saveEvent;

    function __construct(){
        $this->saveEvent = new \PhpCore\Event("Product.save");
        $this->saveEvent->addListeners(array($this,"onSave"));
        
    }

    function save(){
        $code = rand(1,9);
        echo "Result code($code). Save product [{$this->name}#{$this->code}]".PHP_EOL;
        $this->saveEvent->fire($this, $code);
    }
    
    function onSave(\PhpCore\Event\Args $ev, $target){
        //$ev->cancel = true;
       var_dump("onSave");

    }


}