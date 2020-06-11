<?php
var_dump((boolean) new stdClass); // bool(true) 
var_dump((bool) "");        // bool(false)
var_dump((bool) 1);         // bool(true)
var_dump((bool) -2);        // bool(true)
var_dump((bool) "foo");     // bool(true)
var_dump((bool) 2.3e5);     // bool(true)
var_dump((bool) array(12)); // bool(true)
var_dump((bool) array());   // bool(false)
var_dump((bool) "false");   // bool(true)
var_dump((bool) false);   // bool(false)
var_dump((bool) true);   // bool(true)
var_dump((bool) null);   // bool(false)
?> 