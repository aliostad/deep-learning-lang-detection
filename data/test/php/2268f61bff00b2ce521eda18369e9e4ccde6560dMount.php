<?php

namespace PHPixie\Filesystem\Locators\Locator;

class Mount implements \PHPixie\Filesystem\Locators\Locator
{
    protected $locatorRegistry;
    protected $configData;
    
    protected $locator;
    
    public function __construct($locatorRegistry, $configData)
    {
        $this->locatorRegistry = $locatorRegistry;
        $this->configData      = $configData;
    }
    
    public function locate($path, $isDirectory = false)
    {
        return $this->locator()->locate($path, $isDirectory);
    }
    
    protected function locator()
    {
        if($this->locator === null) {
            $name = $this->configData->getRequired('name');
            $this->locator = $this->locatorRegistry->get($name);
        }
        
        return $this->locator;
    }
}