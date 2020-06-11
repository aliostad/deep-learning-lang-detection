<?php
namespace Lulu\Imageboard\Factory\Service\REST\Thread;

use Lulu\Imageboard\Domain\Repository\PostRepositoryInterface;
use Lulu\Imageboard\Domain\Repository\ThreadRepositoryInterface;
use Lulu\Imageboard\Service\REST\Thread\ThreadFeedRESTService;
use Lulu\Imageboard\ServiceManager\FactoryInterface;
use Lulu\Imageboard\ServiceManager\ServiceManagerInterface;

class ThreadFeedRESTServiceFactory implements FactoryInterface
{
    public function createServiceInstance(ServiceManagerInterface $serviceManager) {
        /** @var ThreadRepositoryInterface $threadRepository */
        $threadRepository = $serviceManager->get('ThreadRepository');
        /** @var PostRepositoryInterface $postRepository */
        $postRepository = $serviceManager->get('PostRepository');

        return new ThreadFeedRESTService($threadRepository, $postRepository);
    }
}