<?php
/**
 * Created by Daniel Vidmar.
 * Date: 12/13/13
 * Time: 9:30 AM
 * Version: Beta 1
 * Last Modified: 1/11/14 at 1:35 PM
 * Last Modified by Daniel Vidmar.
 */

class Configuration {

    //Array variable to hold the configurations loaded
    /**
     * @var array
     */
    public $config;

    //Load the configuration in the constructor
    /**
     *
     */
    public function __construct() {
        $this->config = parse_ini_file("resources/config.ini", true);
    }

    //Save the configuration in the destructor
    /**
     *
     */
    public function save() {
        $save = "";
        $save .= ";Trackr Configuration File\n";
        foreach($this->config as $key => $value) {
            (strtolower($key) == "trackr") ? $save .= ";Do not modify the below values.\n" : $save .= ";Modify the below values accordingly.\n";
            $save .= "[".$key."]\n";
            foreach($value as $k => $v) {
                $save .= $k." = ".$v."\n";
            }
            $save .= "\n";
        }
        file_put_contents("resources/config.ini", $save, LOCK_EX);
    }
}