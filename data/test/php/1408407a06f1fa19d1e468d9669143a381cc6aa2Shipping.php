<?php
/**
 * Uthando CMS (http://www.shaunfreeman.co.uk/)
 *
 * @package   Shop\Service\Factory
 * @author    Shaun Freeman <shaun@shaunfreeman.co.uk>
 * @copyright Copyright (c) 2014 Shaun Freeman. (http://www.shaunfreeman.co.uk)
 * @license   see LICENSE.txt
 */

namespace Shop\Service\Factory;

use Shop\Service\Shipping as ShippingService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class Shipping
 *
 * @package Shop\Service\Factory
 */
class Shipping implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
	    /* @var $serviceManager \UthandoCommon\Service\ServiceManager */
	    $serviceManager = $serviceLocator->get('UthandoServiceManager');
	    
	    /* @var $cartOptions \Shop\Options\CartOptions */
	    $cartOptions = $serviceLocator->get('Shop\Options\Cart');
	    $taxService = $serviceLocator->get('Shop\Service\Tax');
	    $countryService = $serviceManager->get('ShopCountry');
	    
	    $shippingService = new ShippingService();
	    $shippingService->setCountryService($countryService);
	    $shippingService->setTaxService($taxService);
		$shippingService->setShippingByWeight($cartOptions->isShippingByWeight());
	    
	    return $shippingService;
	}
}
