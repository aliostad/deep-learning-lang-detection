<?php

namespace Cnerta\Model;

use Cnerta\Model\RepositoryPackage;
use Cnerta\Model\RepositorySimple;

/**
 * @author valérian Girard <valerian.girard@educagri.fr>
 */
class RepositoryFactory
{

    protected $config;

    public function __construct($config)
    {
        $this->config = $config;
    }

    /**
     * @param array $repository
     * @return \Cnerta\Model\RepositoryInterface
     */
    public function getManager($repository)
    {        
        if ($repository["type"] == "package") {
            return new RepositoryPackage($this->config);
        } else {
            return new RepositorySimple();
        }
        
        throw new \Exception("Repository Factory not found for repository defined");
    }

}
