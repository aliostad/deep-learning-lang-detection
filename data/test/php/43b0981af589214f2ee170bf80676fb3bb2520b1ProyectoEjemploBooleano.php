<?php 
$vBoolean = true;

/*La expresion (bool) sirve para convertir el tipo de una variable
  o expresión a booleana, es decir fuerza a que sea un boolean*/
var_dump($vBoolean);	
var_dump((bool) "");
var_dump((bool) "0");
var_dump((bool) 0);
var_dump((bool) 1);
var_dump((bool) -2);
var_dump((bool) "foo");
var_dump((bool) 2.3e5);
var_dump((bool) array(12));
var_dump((bool) array());
var_dump((bool) "false");

/*la funcion is_bool() es para saber si una variable o expresion es
  de tipo boolean*/
var_dump(is_bool("true"));
var_dump(is_bool((bool)"true"));
var_dump(is_bool($vBoolean));
var_dump(is_bool(false));
?>