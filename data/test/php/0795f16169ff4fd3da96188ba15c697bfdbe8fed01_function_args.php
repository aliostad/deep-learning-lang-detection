<?php

class A {
  public $x;

  function show() {
    echo "{$this->x}<br>";
  }
}

function setA($a) {
  $a->x = 2;
}

function setAA($aa) {
  foreach($aa as $a) {
    $a->x = 3;
  }
}

$a = new A();
$a->x = 1;
$a->show();
setA($a);
$a->show();  //shows 2 because $a is reference to object


$aa = array('a' => $a);
setAA($aa);
$a->show();

/////////////

function setB($b) {
  $b = 2;
}

function setAB($ab) {
  foreach($ab as $b) {
    $b = 3;
  }
}

function show($x) {
  echo "{$x}<br>";
}

$b = 1;
show($b);
setB($b);
show($b);

$ab = array('b' => $b);
setAB($ab);
show($b);

$ab['b'] = 4;
show($b);