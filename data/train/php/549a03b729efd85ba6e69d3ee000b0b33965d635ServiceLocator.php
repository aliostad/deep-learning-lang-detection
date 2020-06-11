<?php

namespace EmberChat\Service;

use TechDivision\WebSocketContainer\Application;
use EmberChat\Repository\ClientRepository;
use EmberChat\Repository\ConversationRepository;
use EmberChat\Repository\RoomRepository;
use EmberChat\Repository\UserRepository;

use TechDivision\PersistenceContainerClient\Context\Connection\Factory;


/**
 * Will get replaced by a dependency injection framework in future
 *
 * @package   EmberChatAppServer
 * @author    Matthias Witte <wittematze@gmail.com>
 */
class ServiceLocator
{
    /**
     * @var \TechDivision\WebSocketContainer\Application
     */
    protected $application;

    /**
     * @var UserRepository
     */
    protected $userRepository;

    /**
     * @var ClientRepository
     */
    protected $clientRepository;

    /**
     * @var RoomRepository
     */
    protected $roomRepository;

    /**
     * @var ConversationRepository
     */
    protected $conversationRepository;

    /**
     * Current Version of this server
     *
     * @var string
     */
    protected $serverVersion = '0.0.0';

    /**
     * @var int
     */
    protected $startTime = 0;

    public function __construct(Application $application)
    {

        $this->startTime = time();
        // this hole service locator will get removed in future
        $this->application = $application;

        $connection = Factory::createContextConnection($application->getName());
        $session = $connection->createContextSession();
        $initialContext = $session->createInitialContext();

        $this->setServerVersion();

        $this->userRepository = new UserRepository($initialContext, $this);
        $this->clientRepository = new  ClientRepository();
        $this->roomRepository = new RoomRepository($initialContext);
        $this->conversationRepository = new ConversationRepository();
    }

    /**
     * Reads the package.json and sets version
     */
    protected function setServerVersion()
    {
        $json = file_get_contents($this->application->getWebappPath() . DIRECTORY_SEPARATOR . 'package.json');
        $packageInfo = json_decode($json);
        if ($packageInfo->version) {
            $this->serverVersion = $packageInfo->version;
        }
    }

    /**
     * @return int
     */
    public function getStartTime()
    {
        return $this->startTime;
    }

    /**
     * @return string
     */
    public function getServerVersion()
    {
        return $this->serverVersion;
    }

    /**
     * @param \TechDivision\WebSocketContainer\Application $application
     */
    public function setApplication($application)
    {
        $this->application = $application;
    }

    /**
     * @return \TechDivision\WebSocketContainer\Application
     */
    public function getApplication()
    {
        return $this->application;
    }

    /**
     * @param ClientRepository $clientRepository
     */
    public function setClientRepository(ClientRepository $clientRepository)
    {
        $this->clientRepository = $clientRepository;
    }

    /**
     * @return ClientRepository
     */
    public function getClientRepository()
    {
        return $this->clientRepository;
    }

    /**
     * @param RoomRepository $roomRepository
     */
    public function setRoomRepository(RoomRepository $roomRepository)
    {
        $this->roomRepository = $roomRepository;
    }

    /**
     * @return RoomRepository
     */
    public function getRoomRepository()
    {
        return $this->roomRepository;
    }

    /**
     * @param UserRepository $userRepository
     */
    public function setUserRepository(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }

    /**
     * @return UserRepository
     */
    public function getUserRepository()
    {
        return $this->userRepository;
    }

    /**
     * @param ConversationRepository $conversationRepository
     */
    public function setConversationRepository(ConversationRepository $conversationRepository)
    {
        $this->conversationRepository = $conversationRepository;
    }

    /**
     * @return ConversationRepository
     */
    public function getConversationRepository()
    {
        return $this->conversationRepository;
    }


}