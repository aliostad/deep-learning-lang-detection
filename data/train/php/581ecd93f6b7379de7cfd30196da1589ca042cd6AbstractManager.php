<?php


namespace Security\OAuth\Manager;

use Doctrine\Common\Persistence\ObjectManager;
use Doctrine\Common\Persistence\ObjectRepository;

abstract class AbstractManager
{

    /**
     * @var ObjectManager
     */
    protected $objectManager;

    /**
     * @var ObjectRepository
     */
    protected $objectRepository;

    /**
     * @param ObjectManager    $objectManager
     * @param ObjectRepository $objectRepository
     */
    public function __construct(ObjectManager $objectManager, ObjectRepository $objectRepository)
    {
        $this->objectManager = $objectManager;
        $this->objectRepository = $objectRepository;
    }
}
