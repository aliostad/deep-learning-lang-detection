<?php

/*
 * This file is part of the Orchestra project.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace RomaricDrigon\OrchestraBundle\Core\Repository\Action;

use RomaricDrigon\OrchestraBundle\Core\Repository\RepositoryDefinitionInterface;

/**
 * Class RepositoryActionCollectionBuilder
 * @author Romaric Drigon <romaric.drigon@gmail.com>
 */
class RepositoryActionCollectionBuilder implements RepositoryActionCollectionBuilderInterface
{
    /**
     * @var RepositoryActionBuilderInterface
     */
    protected $repositoryActionBuilder;


    /**
     * @param RepositoryActionBuilderInterface $repositoryActionBuilder
     */
    public function __construct(RepositoryActionBuilderInterface $repositoryActionBuilder)
    {
        $this->repositoryActionBuilder  = $repositoryActionBuilder;
    }

    /**
     * @inheritdoc
     */
    public function build(RepositoryDefinitionInterface $repositoryDefinition)
    {
        $repoName   = $repositoryDefinition->getName();
        $methods    = $repositoryDefinition->getMethods();

        $collection = new RepositoryActionCollection($repoName);

        foreach ($methods as $method) {
            $action = $this->repositoryActionBuilder->build($repositoryDefinition, $method);

            if (null === $action) {
                continue;
            }

            $collection->addAction($action);
        }

        return $collection;
    }
}
