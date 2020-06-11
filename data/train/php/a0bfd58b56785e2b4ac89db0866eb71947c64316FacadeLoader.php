<?php

namespace Raideer\Tweech\Facades;

class FacadeLoader
{
    protected $facades;
    protected $loaded = false;

    public function __construct($list)
    {
        $this->facades = $list;
    }

    public function load()
    {
        if (!$this->loaded) {
            $this->addToAutoloadRegistry();

            $this->loaded = true;
        }
    }

    public function facade($class, $facade)
    {
        $this->facades[$class] = $facade;
    }

    public function loadFacade($facade)
    {
        if (isset($this->facades[$facade])) {
            return class_alias($this->facades[$facade], $facade);
        }
    }

    protected function addToAutoloadRegistry()
    {
        spl_autoload_register([$this, 'loadFacade'], true, true);
    }
}
