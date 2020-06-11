<?php

/**
 * Parrot Framework
 *
 * @author Jason Brown <jason.brown@parrotcageapps.com>
 */

namespace Parrot\Database;

/**
 * Class DatabaseServiceAwareTrait
 * @package Parrot\Database
 */
trait DatabaseServiceAwareTrait
{
    /**
     * @var DatabaseServiceInterface
     */
    protected $databaseService;

    /**
     * Get the Database Service
     *
     * @return DatabaseServiceInterface
     */
    public function getDatabaseService()
    {
        return $this->databaseService;
    }

    /**
     * Set Database Service
     *
     * @param DatabaseServiceInterface $databaseService
     */
    public function setDatabaseService(DatabaseServiceInterface $databaseService)
    {
        $this->databaseService = $databaseService;
    }
}