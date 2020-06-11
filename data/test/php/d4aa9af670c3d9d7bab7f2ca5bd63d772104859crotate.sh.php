<?php

$sh = array();

if (!is_dir("./dump")) {
  $sh[] = "mkdir ./dump";
}

$t = time();
foreach (array(
  'hour-1-4' => date('H', $t) % 4,
  'hour-6-4' => floor(date('H', $t) / 6) * 6,
  'weekday' => strtolower(date('D', $t)),
  'month-1-4' => date('m', $t) % 4,
  'month-3-4' => floor(date('m', $t) / 3 * 3),
  'year' => date('Y', $t),
) as $type => $tick) {
  if (!is_dir("./dump/$type")) {
    $sh[] = "mkdir ./dump/$type";
  }
  else {
    foreach (scandir("./dump/$type") as $x) {
      if (1
        && $x !== '.'
        && $x !== '..'
        && $x !== $tick
        && is_link("./dump/$type/$x")
        && readlink("./dump/$type/$x") === "../now"
      ) {
        $sh[] = "rm ./dump/$type/$x";
        $sh[] = "cp -r ./dump/now ./dump/$type/$x";
      }
    }
    if (is_dir("./dump/$type/$tick")) {
      $sh[] = "rm -r ./dump/$type/$tick";
    }
    elseif (0
      || is_link("./dump/$type/$tick")
      || is_file("./dump/$type/$tick")
    ) {
      $sh[] = "rm ./dump/$type/$tick";
    }
  }
  $sh[] = "ln -s ../now ./dump/$type/$tick";
}

print implode("\n", $sh);
