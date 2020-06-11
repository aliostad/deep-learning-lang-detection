<?php

/**
 * helper to dump variables
 */
function dump()
{
    $dumper = Marmotz\Dumper\Dump::factory();

    foreach (func_get_args() as $variable) {
        $dumper->dump($variable);
        echo PHP_EOL;
    }
}

/**
 * helper to dump variables and die
 */
function dumpd()
{
    call_user_func_array('dump', func_get_args());

    die;
}

/**
 * helper to get variables dump
 *
 * @return string
 */
function getDump()
{
    $dumper = Marmotz\Dumper\Dump::factory();

    $dump = '';

    foreach (func_get_args() as $variable) {
        $dump .= $dumper->getDump($variable) . PHP_EOL;
    }

    return $dump;
}