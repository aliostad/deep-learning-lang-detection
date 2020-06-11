<?php

// BONO
return array(
    // Application Controller using Kraken Container
    'kraken.controllers' => array(
        'default' => '\\KrisanAlfa\\Kraken\\Controller\\NormController',
        'dependencies' => array(
            'App\\Entry\\Contract\\TagsRepositoryInterface' => 'App\\Entry\\Repository\\TagsRepository',
            'App\\Entry\\Contract\\QuestionTagsRepositoryInterface' => 'App\\Entry\\Repository\\QuestionTagsRepository',
            'App\\Entry\\Contract\\QuestionRepositoryInterface' => 'App\\Entry\\Repository\\QuestionRepository',
        ),
        'mapping' => array(
            '/question' => '\\App\\Controller\\QuestionController'
        )
    ),
);
