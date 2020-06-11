<?php
/**
 * Aero Framework
 *
 * @category    Aero
 * @author      Alex Zavacki
 */

namespace Aero\Application\Resource;

/**
 * Standard resource manager
 *
 * @category    Aero
 * @package     Aero_Application
 * @subpackage  Aero_Application_Resource
 * @author      Alex Zavacki
 */
class ResourceManager implements ResourceManagerInterface
{
    /**
     * @var \Aero\Application\Resource\Locator\ResourceLocatorInterface
     */
    protected $locator;


    /**
     * Constructor.
     *
     * @param \Aero\Application\Resource\Locator\ResourceLocatorInterface $locator
     */
    public function __construct(Locator\ResourceLocatorInterface $locator = null)
    {
        $this->locator = $locator;
    }

    /**
     * Find resource location
     *
     * @param  string $resource
     * @return string
     */
    public function locate($resource)
    {
        return $this->getLocator()->locate($resource);
    }

    /**
     * @param \Aero\Application\Resource\Locator\ResourceLocatorInterface $locator
     */
    public function setLocator($locator)
    {
        $this->locator = $locator;
        return $this;
    }

    /**
     * @return \Aero\Application\Resource\Locator\ResourceLocatorInterface
     */
    public function getLocator()
    {
        if (!$this->locator instanceof Locator\ResourceLocatorInterface) {
            $this->locator = $this->createDefaultLocator();
        }
        return $this->locator;
    }

    /**
     * @return \Aero\Application\Resource\Locator\ResourceLocatorInterface
     */
    public function createDefaultLocator()
    {
        return new Locator\StandardResourceLocator();
    }
}
