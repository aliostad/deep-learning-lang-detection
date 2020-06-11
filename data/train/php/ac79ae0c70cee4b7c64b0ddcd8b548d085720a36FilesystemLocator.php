<?php

namespace PHPixie\BundleFramework\Configuration;

use PHPixie\Filesystem\Locators\Locator;

/**
 * Merges filesystem locators
 */
class FilesystemLocator implements \PHPixie\Filesystem\Locators\Locator
{
    /**
     * @var \PHPixie\Bundles\FilesystemLocators
     */
    protected $bundleLocators;

    /**
     * @var Locator
     */
    protected $overridesLocator;

    /**
     * Constructor
     * @param \PHPixie\Bundles\FilesystemLocators $bundleLocators
     * @param Locator|null $overridesLocator
     */
    public function __construct($bundleLocators, $overridesLocator = null)
    {
        $this->bundleLocators  = $bundleLocators;
        $this->overridesLocator = $overridesLocator;
    }

    /**
     * @inheritdoc
     */
    public function locate($name, $isDirectory = false)
    {
        if($this->overridesLocator !== null) {
            $path = $this->overridesLocator->locate($name, $isDirectory);
            if($path !== null) {
                return $path;
            }
        }
        
        $split = explode(':', $name, 2);
        if(count($split) !== 2 ) {
            return null;
        }
        
        list($locatorName, $name) = $split;
        
        $locator = $this->getLocator($locatorName);
        
        if($locator === null) {
            return null;
        }
        
        return $locator->locate($name, $isDirectory);
    }

    /**
     * @param string $name
     * @return Locator
     */
    protected function getLocator($name)
    {
        return $this->getBundleLocator($name);
    }

    /**
     * @param string $name
     * @return Locator
     */
    protected function getBundleLocator($name)
    {
        return $this->bundleLocators->bundleLocator($name, false);
    }
}