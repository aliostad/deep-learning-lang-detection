<?php

namespace Wsio\Tests\Ontrapor\Facade;

use Wsio\Ontraport\Facade\Ontraport;
use Wsio\Tests\Ontraport\LaravelTestCase;
use GrahamCampbell\TestBenchCore\FacadeTrait;
use Wsio\Ontraport\Ontraport as OntraportManager;

class OntraportTest extends LaravelTestCase
{
    use FacadeTrait;

    /**
     * Get the facade accessor.
     *
     * @return string
     */
    protected function getFacadeAccessor()
    {
        return OntraportManager::class;
    }

    /**
     * Get the facade class.
     *
     * @return string
     */
    protected function getFacadeClass()
    {
        return Ontraport::class;
    }

    /**
     * Get the facade root.
     *
     * @return string
     */
    protected function getFacadeRoot()
    {
        return OntraportManager::class;
    }
}
