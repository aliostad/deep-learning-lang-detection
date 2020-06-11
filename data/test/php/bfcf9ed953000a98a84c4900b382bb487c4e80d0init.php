<?php

function copyFile($src, $dest, $append = true)
{
    $prefix = __DIR__ . '/';
    if ( $append ) {
        $prefix .= 'data/';
    }
    copy($prefix . $src, $prefix . $dest);
}

copyFile('config.example.json', 'config.json', false);
copyFile('sample.city.json', 'city.json');
copyFile('sample.event.json', 'event.json');
copyFile('sample.event_user.json', 'event_user.json');
copyFile('sample.interest.json', 'interest.json');
copyFile('sample.interest_event.json', 'interest_event.json');
copyFile('sample.session.json', 'session.json');
copyFile('sample.user.json', 'user.json');
copyFile('sample.user_event.json', 'user_event.json');
copyFile('sample.city_event.json', 'city_event.json');