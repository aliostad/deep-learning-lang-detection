<?php
/* vim: set expandtab tabstop=4 shiftwidth=4 */
/**
 * LundCustomer
 *
 * @category   Zend
 * @package    LundCustomer
 * @subpackage Config
 * @author     Raven Sampson <rsampson@thesmartdata.com>
 * @license    http://opensource.org/licenses/BSD-3-Clause BSD 3-Clause
 * @version    GIT: $Id$
 * @since      File available since Release 0.1.0
 */

namespace LundCustomer;

return array(
    'abstract_factories' => array(
        'Zend\Cache\Service\StorageCacheAbstractServiceFactory',
        'Zend\Log\LoggerAbstractServiceFactory',
    ),
    'aliases' => array(
        'LundCustomer\ObjectManager' => 'Doctrine\ORM\EntityManager',
    ),
    'invokables' => array(
        'LundCustomer\Entity\CustomerPrototype'         => 'LundCustomer\Entity\Customer',
        'LundCustomer\Entity\CustomerTransmitPrototype' => 'LundCustomer\Entity\CustomerTransmit',
        'LundCustomer\Entity\RetailerPrototype'         => 'LundCustomer\Entity\Retailer',
    ),
    'factories' => array(
        'LundCustomer\Options\LundCustomerOptions'        => 'LundCustomer\Options\Factory\LundCustomerOptionsFactory',
        'LundCustomer\Config'                             => 'LundCustomer\Factory\ConfigFactory',
        'LundCustomer\Repository\CustomerRepository'      => 'LundCustomer\Repository\Factory\CustomerRepositoryFactory',
        'LundCustomer\Service\CustomerService'            => 'LundCustomer\Service\Factory\CustomerServiceFactory',
        'LundCustomer\Service\ParseCustomerService'       => 'LundCustomer\Service\Factory\ParseCustomerServiceFactory',
        'LundCustomer\Service\CustomerTransmitService'    => 'LundCustomer\Service\Factory\CustomerTransmitServiceFactory',
        'LundCustomer\Repository\CustomerTransmitRepository' => 'LundCustomer\Repository\Factory\CustomerTransmitRepositoryFactory',
        'LundCustomer\Repository\RetailerRepository'         => 'LundCustomer\Repository\Factory\RetailerRepositoryFactory',
        'LundCustomer\Service\RetailerService'               => 'LundCustomer\Service\Factory\RetailerServiceFactory',
        'LundCustomer\Repository\PostalCodeRepository'       => 'LundCustomer\Repository\Factory\PostalCodeRepositoryFactory',
    ),
);
