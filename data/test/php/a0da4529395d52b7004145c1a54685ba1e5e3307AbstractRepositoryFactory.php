<?php
namespace Mindweb\Db;

abstract class AbstractRepositoryFactory
{
    /**
     * @var array
     */
    protected $repositories = array();

    /**
     * @var Connection
     */
    protected $connection;

    /**
     * @param Connection $connection
     */
    public function __construct(Connection $connection)
    {
        $this->connection = $connection;
    }

    /**
     * @return string
     */
    abstract protected function getVendor();

    /**
     * @return string
     */
    abstract protected function getNamespace();

    /**
     * @return array
     */
    abstract protected function getMapping();

    /**
     * @param string $repository
     * @return Repository
     */
    public function get($repository)
    {
        $repositoryClassName = sprintf('%s\\%s\\Repository\\',
            $this->getVendor(), $this->getNamespace()
        );

        $mapping = $this->getMapping();
        if (!isset($mapping[$repository])) {
            throw new Exception\NotMappedRepositoryException($repository);
        }
        $repositoryClassName .= $mapping[$repository];
        $repositoryClassName .= 'Repository';

        if (!isset($this->repositories[$repositoryClassName])) {
            $this->repositories[$repositoryClassName] = new $repositoryClassName(
                $this->connection->getHandler()
            );
        }

        if (!$this->repositories[$repositoryClassName] instanceof Repository) {
            throw new Exception\InvalidRepositoryClassException($repository);
        }

        return $this->repositories[$repositoryClassName];
    }
}