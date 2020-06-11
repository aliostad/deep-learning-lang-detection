<?php
// Require the person class file
require ("Person.class.php");
$person = new Person();

// Create new person
$person->Firstname = "Kona";
$person->Age = "20";
$person->Sex = "F";
$creation = $person::Create();
dump("person create");
dump($creation);

// Update Person Info
$person->Id = "4";
$person->Age = "32";
$saved = $person::Save();
dump("person save");
dump($saved);

dump("person find return array");
// Find person
$person->Id = "3";
$data=$person::Find();
dump($data);

dump("preson return object");
dump($person->Firstname);

// Delete person
$person->Id = "10";
$delete = $person::Delete();
dump("person delete");
dump($delete);

// Get all persons
$persons = $person::all();
dump($person);
dump("person all");

dump("person max");
dump($person::max("age"));
dump("person min");
dump($person::min("age"));
dump("person sum");
dump($person::sum("age"));
dump("person avg");
dump($person::avg("age"));
dump("person count");
dump($person::count("age"));

dump("preson update");
$ps = new person();
if ($persons) {
    $data = $persons[0];
    $data['Firstname']="Firstname".time();
    dump($data);
    if ($data) {
        foreach ($data as $k => $v) $ps->$k = $v;
    }
}
dump($ps::save());

dump("person query");
$sql="SELECT * FROM `persons` WHERE `Id` > '0' ORDER BY `Id` DESC LIMIT 3;";
dump($sql);
$tmp=$person::query($sql);
dump($tmp);

dump("show columns form table");
$columns=$person->columns();
dump($columns);

dump("rip the nokey in table");
$data=array();
$data['id']=0;
$data['Id']=0;
$data['Age']=20;
$dataok=$person->ripkey($data);
dump($dataok);





exit;



function dump($v) {
    echo '<pre>';
    print_r($v);
    echo '</pre>';
}
