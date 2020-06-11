define(function () {
    'use strict';

    // The routes for the application. This module returns a function.
    // `match` is match method of the Router
    return function (match) {
        match('', 'landing#show');
        match('add', 'metadata#show');
        match('close', 'close#show');
        match('data', 'data#show');
        match('delete', 'delete#show');
        match('dsd', 'dsd#show');
        match('landing', 'landing#show');
        match('metadata', 'metadata#show');
        match('resume', 'resume#show');
        match('search', 'search#show');
    };
});
