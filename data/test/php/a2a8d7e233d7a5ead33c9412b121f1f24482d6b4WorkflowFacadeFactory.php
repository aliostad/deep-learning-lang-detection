<?php
/*
 * This file is part of the codeliner/wf-configurator-backend package.
 * (c) Alexander Miertsch <kontakt@codeliner.ws>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace GingerWfConfigBackend\Facade\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use GingerWfConfigBackend\Facade\WorkflowFacade;
/**
 * ServiceFactory of a WorkflowFacade
 * 
 * @author Alexander Miertsch <kontakt@codeliner.ws>
 */
class WorkflowFacadeFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $wfFacade = new WorkflowFacade();
        $wfFacade->setWorkflowRepository($serviceLocator->get('workflow_config_repositoy'));
        return $wfFacade;
    }
}
