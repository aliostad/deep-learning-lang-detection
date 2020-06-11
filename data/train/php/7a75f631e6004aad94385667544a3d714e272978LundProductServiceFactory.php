<?php
/* vim: set expandtab tabstop=4 shiftwidth=4 */
/*
 * LundProducts
 *
 * PHP version 5.5
 *
 * @category   Zend
 * @package    LundProducts\Service
 * @subpackage Factory
 * @author     Raven Sampson <rsampson@thesmartdata.com>
 * @license    http://opensource.org/licenses/BSD-3-Clause BSD 3-Clause
 * @version    GIT: $Id$
 * @since      File available since Release 1.0.0
 */

namespace LundProducts\Service\Factory;

use LundProducts\Service\LundProductService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Service factory that instantiates {@see LundProductService}.
 */
class LundProductServiceFactory implements FactoryInterface
{
    /**
     * createService(): defined by FactoryInterface.
     *
     * @see    FactoryInterface::createService()
     * @param  ServiceLocatorInterface $serviceLocator
     * @return LundProductService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $lundProductService = new LundProductService(
            $serviceLocator->get('LundProducts\ObjectManager'),
            $serviceLocator->get('LundProducts\Service\BrandsService'),
            $serviceLocator->get('LundProducts\Service\ProductCategoryService'),
            $serviceLocator->get('LundProducts\Service\ProductLineService'),
            $serviceLocator->get('LundProducts\Service\ProductLineAssetService'),
            $serviceLocator->get('LundProducts\Service\PartService'),
            $serviceLocator->get('LundProducts\Service\PartAssetService'),
            $serviceLocator->get('LundProducts\Service\VehCollectionService'),
            $serviceLocator->get('LundProducts\Service\ProductReviewService'),
            $serviceLocator->get('LundProducts\Repository\PartVehCollectionRepository'),
            $serviceLocator->get('LundProducts\Service\ChangesetsService'),
            $serviceLocator->get('LundProducts\Service\ChangesetDetailsService'),
            $serviceLocator->get('LundProducts\Service\BrandProductCategoryService'),
            $serviceLocator->get('LundProducts\Service\ProductLineFeatureService')
        );

        return $lundProductService;
    }
}
