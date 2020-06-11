<?php

/**
 * Autoload a facade
 * 
 * @param  string $class
 * 
 * @return void
 */
function autoload($class) {
  $hasNamespace = strstr($class, NS);

  $facadeExists = false;

  $namespace  = null;
  $location   = null;
  $file       = null;
  $category   = null;

  if($hasNamespace){
    $explode = explode(NS, $class);

    if(count($explode) === 3){
      list($core, $location, $class) = $explode;
    }else{
      list($core, $category, $location, $class) = $explode;
    }

  }

  $file = "{$class}.php";
  
  $path      = ALCHEMY_CORE . DS . 'Facade' . DS . $file;
  $namespace = NS . 'Alchemy' . NS . 'Facade' . NS . $class;

  $facadeExists = is_readable($path);

  if(!$facadeExists){
    $path      = str_replace('Facade', $location, $path);
    $namespace = str_replace('Facade', $namespace, $namespace); 
  }

  if(is_readable($path)){
    require_once $path;
  }

}

spl_autoload_register('autoload');