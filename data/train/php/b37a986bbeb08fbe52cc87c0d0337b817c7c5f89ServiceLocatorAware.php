<?php
/**
 * Aero Framework
 *
 * @category    Aero
 * @author      Alex Zavacki
 */

namespace Aero\Std\Di;

/**
 * Service locator aware interface
 *
 * @category    Aero
 * @package     Aero_Std
 * @subpackage  Aero_Std_Di
 * @author      Alex Zavacki
 */
interface ServiceLocatorAware
{
    /**
     * Set the locator
     *
     * @param \Aero\Std\Di\ServiceLocator $locator
     */
    public function setLocator(ServiceLocator $locator);

    /**
     * Get the locator
     *
     * @return \Aero\Std\Di\ServiceLocator
     */
    public function getLocator();
}
