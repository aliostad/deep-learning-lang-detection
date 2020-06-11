<?php


namespace Application\Model\Mapper;

/**
 * Class RepositoryMapperAwareTrait
 * @package Application\Model\Mapper
 * @satisfies RepositoryMapperAwareInterface
 */
trait RepositoryMapperAwareTrait
{
    /** @var  RepositoryMapper; */
    private $repositoryMapper;

    /**
     * @return RepositoryMapper
     */
    public function getRepositoryMapper()
    {
        return $this->repositoryMapper;
    }

    /**
     * @param RepositoryMapper $repositoryMapper
     * @return self
     */
    public function setRepositoryMapper(RepositoryMapper $repositoryMapper)
    {
        $this->repositoryMapper = $repositoryMapper;
        return $this;
    }

}