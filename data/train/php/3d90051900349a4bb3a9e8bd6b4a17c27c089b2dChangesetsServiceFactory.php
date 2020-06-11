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

use LundProducts\Service\ChangesetsService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Service factory that instantiates {@see ChangesetsService}
 */
class ChangesetsServiceFactory implements FactoryInterface
{
    /**
     * Create Changeset service from factory
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return ChangesetsService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $changesetsService = new ChangesetsService(
            $serviceLocator->get('LundProducts\ObjectManager'),
            $serviceLocator->get('LundProducts\Repository\ChangesetsRepository'),
            $serviceLocator->get('LundProducts\Repository\PartsRepository'),
            $serviceLocator->get('LundProducts\Service\ParseMasterService'),
            $serviceLocator->get('LundProducts\Service\ParseSupplementService'),
            $serviceLocator->get('LundProducts\Service\ChangesetDetailsService'),
            $serviceLocator->get('LundProducts\Service\ChangesetDetailsVehiclesService'),
            $serviceLocator->get('LundProducts\Repository\PartVehCollectionRepository'),
            $serviceLocator->get('doctrine.entitymanager.orm_default'),
            $serviceLocator->get('LundProducts\Repository\VehCollectionRepository'),
            $serviceLocator->get('RocketAdmin\Service\AuditService'),
            $serviceLocator->get('LundProducts\Service\ProductLineService')
        );

        return $changesetsService;
    }
}
