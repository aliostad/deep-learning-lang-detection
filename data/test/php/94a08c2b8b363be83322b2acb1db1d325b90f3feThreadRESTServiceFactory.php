<?php
namespace Lulu\Imageboard\Factory\Service\REST;

use Lulu\Imageboard\Domain\Repository\BoardRepositoryInterface;
use Lulu\Imageboard\Domain\Repository\ThreadRepositoryInterface;
use Lulu\Imageboard\Service\REST\ThreadRESTService;
use Lulu\Imageboard\ServiceManager\FactoryInterface;
use Lulu\Imageboard\ServiceManager\ServiceManagerInterface;

class ThreadRESTServiceFactory implements FactoryInterface
{
    public function createServiceInstance(ServiceManagerInterface $serviceManager) {
        /** @var ThreadRepositoryInterface $threadRepository */
        $threadRepository = $serviceManager->get('ThreadRepository');
        /** @var BoardRepositoryInterface $boardRepository */
        $boardRepository = $serviceManager->get('BoardRepository');

        return new ThreadRESTService($threadRepository, $boardRepository);
    }
}