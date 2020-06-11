<?php

if (!defined('BASEPATH')) exit('No direct script access allowed');

$route['show-(\d+).html']                       = 'show/index/id/$1'; // 对应规则：show-{id}.html
$route['show-(\d+)-(\d+).html']                 = 'show/index/id/$1/page/$2'; // 对应规则：show-{id}-{page}.html
$route['read-(\d+).html']                       = 'extend/index/id/$1'; // 对应规则：read-{id}.html


/* 以下是规则备注 */

$note['show-(\d+).html']                       = "show-{id}.html";
$note['show-(\d+)-(\d+).html']                 = "show-{id}-{page}.html";
$note['read-(\d+).html']                       = "read-{id}.html";
