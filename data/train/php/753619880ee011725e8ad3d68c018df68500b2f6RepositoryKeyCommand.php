<?php declare(strict_types=1);

namespace ApiClients\Client\Travis\CommandBus\Command;

use WyriHaximus\Tactician\CommandHandler\Annotations\Handler;

/**
 * @Handler("ApiClients\Client\Travis\CommandBus\Handler\RepositoryKeyHandler")
 */
final class RepositoryKeyCommand
{
    /**
     * @var string
     */
    private $repository;

    /**
     * @param string $repository
     */
    public function __construct(string $repository)
    {
        $this->repository = $repository;
    }

    /**
     * @return string
     */
    public function getRepository(): string
    {
        return $this->repository;
    }
}
