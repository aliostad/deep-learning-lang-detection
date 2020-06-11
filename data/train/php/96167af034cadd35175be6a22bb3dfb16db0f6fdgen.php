<?php

function save($val, $name) {
    $f = fopen("$name.phps", "w");
    fwrite($f, serialize($val));
    fclose($f);
}

class Blah {
    private $foo = 1;
    protected $bar = 2;
    public $baz = 3;
}

save(3, "int");
save(252873459, "biggerint");
save(PHP_INT_MAX*3, "overflowint");
save(-70, "negativeint");
save(3.5, "float");
save("foo", "string");
save("", "empty-string");
save(true, "bool");
save(false, "bool-false");
save(null, "null");
save(array(), "empty-array");
save(array(1,2,3), "array");
save(array(0 => 1, 3 => 2), "tricky-array");
save(array("foo" => 1, "bar" => 2), "assoc-array");
save(array(1 => "a", "foo" => "bar"), "mixed-array");
save(new Blah, "object");
save('foo"baz', "quotestring");
save(get_object_vars(new Blah), "objectvars");
