<?php

namespace Behat\Borg\Release;

/**
 * Represents a repository release.
 */
final class Release
{
    /**
     * @var Repository
     */
    private $repository;
    /**
     * @var Version
     */
    private $version;

    /**
     * Initializes release.
     *
     * @param Repository $repository
     * @param Version    $version
     */
    public function __construct(Repository $repository, Version $version)
    {
        $this->repository = $repository;
        $this->version = $version;
    }

    /**
     * Returns release repository.
     *
     * @return Repository
     */
    public function repository()
    {
        return $this->repository;
    }

    /**
     * Returns release version.
     *
     * @return Version
     */
    public function version()
    {
        return $this->version;
    }

    /**
     * Returns string representation of release.
     *
     * @return string
     */
    public function __toString()
    {
        return $this->repository . '/' . $this->version;
    }
}
