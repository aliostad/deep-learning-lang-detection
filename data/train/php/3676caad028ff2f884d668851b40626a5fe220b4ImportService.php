<?php

namespace Soliloquy\AppBundle\Service;

class ImportService
{
    protected $provider;

    protected $dumpManager;

    public function __construct($provider, $dumpManager)
    {
        $this->provider = $provider;

        $this->dumpManager = $dumpManager;
    }

    public function importUserMovies($parameters)
    {
        $movies = $this->provider->getUserMovies($parameters);

        $dump = $this->dumpManager->createDump($movies);

        $this->dumpManager->persistDump($dump);

        return $dump;
    }
}
