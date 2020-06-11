<?php
namespace ConfigExamplesBundle\Locator;

use Symfony\Component\Config\FileLocatorInterface;

class YamlLocator implements FileLocatorInterface
{
    private $locator;
    private $basePath;

    function __construct($basePath, FileLocatorInterface $fileLocator)
    {
        $this->basePath = $basePath;
        $this->locator = $fileLocator;
    }

    public function locate($name, $currentPath = null, $first = true)
    {
        return  $this->locator->locate($name, $this->basePath, $first);
    }
}
