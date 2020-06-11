<?php

/*
 * This file is part of the Kreta package.
 *
 * (c) Beñat Espiña <benatespina@gmail.com>
 * (c) Gorka Laucirica <gorka.lauzirika@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Kreta\Component\VCS\Serializer\Github;

use Kreta\Component\VCS\Factory\CommitFactory;
use Kreta\Component\VCS\Repository\BranchRepository;
use Kreta\Component\VCS\Repository\RepositoryRepository;
use Kreta\Component\VCS\Serializer\Interfaces\SerializerInterface;

/**
 * Class CommitSerializer.
 *
 * @author Beñat Espiña <benatespina@gmail.com>
 * @author Gorka Laucirica <gorka.lauzirika@gmail.com>
 */
class CommitSerializer implements SerializerInterface
{
    /**
     * The commit factory.
     *
     * @var \Kreta\Component\VCS\Factory\CommitFactory
     */
    protected $factory;

    /**
     * The repository repository.
     *
     * @var \Kreta\Component\VCS\Repository\RepositoryRepository
     */
    protected $repositoryRepository;

    /**
     * The branch repository.
     *
     * @var \Kreta\Component\VCS\Repository\BranchRepository
     */
    protected $branchRepository;

    /**
     * Constructor.
     *
     * @param \Kreta\Component\VCS\Factory\CommitFactory           $factory              The factory
     * @param \Kreta\Component\VCS\Repository\RepositoryRepository $repositoryRepository The repository repository
     * @param \Kreta\Component\VCS\Repository\BranchRepository     $branchRepository     The branch repository
     */
    public function __construct(
        CommitFactory $factory,
        RepositoryRepository $repositoryRepository,
        BranchRepository $branchRepository
    ) {
        $this->factory = $factory;
        $this->repositoryRepository = $repositoryRepository;
        $this->branchRepository = $branchRepository;
    }

    /**
     * {@inheritdoc}
     */
    public function deserialize($json)
    {
        $json = json_decode($json, true);

        $jsonCommit = $json['head_commit'];

        $repository = $this->repositoryRepository->findOneBy(['name' => $json['repository']['full_name']]);
        if (!$repository) {
            return;
        }

        $branchName = str_replace('refs/heads/', '', $json['ref']);
        $branch = $this->branchRepository->findOrCreateBranch($repository, $branchName);

        $commit = $this->factory->create($jsonCommit['id'], $jsonCommit['message'], $branch,
            $jsonCommit['author']['username'], $jsonCommit['url']);

        return $commit;
    }
}
