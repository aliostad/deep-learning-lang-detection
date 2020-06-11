<?php

namespace igorw\lambda\krivine;

require 'vendor/autoload.php';

// ['λ', 1]
$identity = ['λ', 'x', 'x'];

// λ λ 2
$k = ['λ', 'x', ['λ', 'y', 'x']];

// λ λ λ 3 1 (2 1)
$s = ['λ', 'x', ['λ', 'y', ['λ', 'z', [['x', 'z'], ['y', 'z']]]]];

// λ (λ 1 (λ 1)) (λ 2 1)
$x = ['λ', 'z', [['λ', 'y', ['y', ['λ', 'x', 'x']]], ['λ', 'x', ['z', 'x']]]];

// omega: loops forever
// (λf.f f) (λf.f f)
$omega = [['λ', 'f', ['f', 'f']], ['λ', 'f', ['f', 'f']]];

// var_dump(de_bruijn($identity));
// var_dump(de_bruijn($k));
// var_dump(de_bruijn($s));
// var_dump(de_bruijn($x));
// var_dump(compile(de_bruijn($identity)));
// var_dump(evaluate([
//     ['constant', 5],
// ]));
// var_dump(de_bruijn(
//     [[['λ', 'x', ['λ', 'y', 'y']], 5], 6]
// ));
// var_dump(compile(de_bruijn(
//     [[['λ', 'x', ['λ', 'y', 'y']], 5], 6]
// )));
// var_dump(evaluate(compile(de_bruijn(
//     [[['λ', 'x', ['λ', 'y', 'y']], 5], 6]
// ))));
// var_dump(evaluate(compile(de_bruijn([$identity, 42]))));
// var_dump(evaluate(compile(de_bruijn([$k, 42]))));
// var_dump(evaluate(compile(de_bruijn($omega))));
