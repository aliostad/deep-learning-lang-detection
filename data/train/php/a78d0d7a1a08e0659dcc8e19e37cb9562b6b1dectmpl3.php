<?php

$t = new TextTemplate();

var_dump(isset($t['tmp']));
var_dump(count($t));
print "\n";

$t['tmp'] = 'TEST';
var_dump(isset($t['tmp']));
var_dump(count($t));
var_dump($t['tmp']);
var_dump($t->get('tmp'));
print "\n";

unset($t['tmp']);
var_dump(isset($t['tmp']));
var_dump(count($t));

print "\n";
print "\n";


$t = new TextTemplate();
print "\n";

var_dump(isset($t['tmp']));
var_dump(count($t));
print "\n";

$t->set('tmp', 'TEST');
var_dump(isset($t['tmp']));
var_dump(count($t));
var_dump($t['tmp']);
var_dump($t->get('tmp'));
print "\n";

unset($t['tmp']);
var_dump(isset($t['tmp']));
var_dump(count($t));

print "\n";
print "\n";

$t = new TextTemplate();
print "\n";

var_dump(isset($t['tmp']));
var_dump(count($t));
print "\n";

$t->set(array('tmp' => 'TEST'));
var_dump(isset($t['tmp']));
var_dump(count($t));
var_dump($t['tmp']);
var_dump($t->get('tmp'));
print "\n";

unset($t['tmp']);
var_dump(isset($t['tmp']));
var_dump(count($t));

print "\n";
print "\n";

$t = new TextTemplate();
print "\n";

var_dump(isset($t['tmp']));
var_dump(count($t));
print "\n";

$t->set('tmp', 'TEST');
$t->set('test', 'other');
var_dump(isset($t['tmp']));
var_dump(count($t));
var_dump($t['tmp']);
var_dump($t->get('tmp'));
var_dump($t['test']);
var_dump($t->get('test'));
var_dump($t->getAll());
print "\n";

unset($t['tmp']);
var_dump(isset($t['tmp']));
var_dump(count($t));


print "\n";
print "\n";

$t = new TextTemplate();
print "\n";

class tmptest {
  function __toString() {
    return 'THIS WAS A CLASS';
  }
}

$t->set('TAG', 'answer');
$t->compile('<!--{TAG}-->');
var_dump($t->render());
var_dump($t->render(array('TAG' => 42)));
var_dump($t->render(array('TAG' => null)));
var_dump($t->render(array('TAG' => true)));
var_dump($t->render(array('TAG' => false)));
var_dump($t->render(array('TAG' => 42.5)));
var_dump($t->render(array('TAG' => array())));
var_dump($t->render(array('TAG' => array('A'=>'b'))));
var_dump($t->render(array('TAG' => new tmptest())));
var_dump($t->render());

