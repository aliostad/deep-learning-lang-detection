<?php

namespace LooplineSystems\IssueManager\Library\Github;

class RepositoryInformation
{

    /**
     * @var string
     */
    protected $repositoryNamespace;

    /**
     * @var string
     */
    protected $repositoryName;

    /**
     * @var int
     */
    protected $issueId;

    /**
     * @return int
     */
    public function getIssueId()
    {
        return $this->issueId;
    }

    /**
     * @param int $issueId
     */
    public function setIssueId($issueId)
    {
        $this->issueId = $issueId;
    }

    /**
     * @return string
     */
    public function getRepositoryName()
    {
        return $this->repositoryName;
    }

    /**
     * @param string $repositoryName
     */
    public function setRepositoryName($repositoryName)
    {
        $this->repositoryName = $repositoryName;
    }

    /**
     * @return string
     */
    public function getRepositoryNamespace()
    {
        return $this->repositoryNamespace;
    }

    /**
     * @param string $repositoryNamespace
     */
    public function setRepositoryNamespace($repositoryNamespace)
    {
        $this->repositoryNamespace = $repositoryNamespace;
    }

    /**
     * @param RepositoryInformation $repositoryInformationCompare
     * @return bool
     */
    public function isSame(RepositoryInformation $repositoryInformationCompare)
    {
        return ($repositoryInformationCompare == $this);
    }

}
