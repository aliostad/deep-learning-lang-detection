<?php

namespace RedDevil\EntityManager;

class DatabaseContext
{
    private $conferencesparticipantsRepository;
	private $conferencesRepository;
	private $hallsRepository;
	private $lecturebreaksRepository;
	private $lecturesparticipantsRepository;
	private $lecturesRepository;
	private $messagesRepository;
	private $notificationsRepository;
	private $rolesRepository;
	private $speakerinvitationsRepository;
	private $usersRepository;
	private $usersRolesRepository;
	private $venuereservationrequestsRepository;
	private $venuesRepository;

    private $repositories = [];

    /**
     * DatabaseContext constructor.
     
     */
    public function __construct()
    {
        $this->conferencesparticipantsRepository = \RedDevil\Repositories\ConferencesparticipantsRepository::create();
		$this->conferencesRepository = \RedDevil\Repositories\ConferencesRepository::create();
		$this->hallsRepository = \RedDevil\Repositories\HallsRepository::create();
		$this->lecturebreaksRepository = \RedDevil\Repositories\LecturebreaksRepository::create();
		$this->lecturesparticipantsRepository = \RedDevil\Repositories\LecturesparticipantsRepository::create();
		$this->lecturesRepository = \RedDevil\Repositories\LecturesRepository::create();
		$this->messagesRepository = \RedDevil\Repositories\MessagesRepository::create();
		$this->notificationsRepository = \RedDevil\Repositories\NotificationsRepository::create();
		$this->rolesRepository = \RedDevil\Repositories\RolesRepository::create();
		$this->speakerinvitationsRepository = \RedDevil\Repositories\SpeakerinvitationsRepository::create();
		$this->usersRepository = \RedDevil\Repositories\UsersRepository::create();
		$this->usersRolesRepository = \RedDevil\Repositories\UsersRolesRepository::create();
		$this->venuereservationrequestsRepository = \RedDevil\Repositories\VenuereservationrequestsRepository::create();
		$this->venuesRepository = \RedDevil\Repositories\VenuesRepository::create();

        $this->repositories[] = $this->conferencesparticipantsRepository;
		$this->repositories[] = $this->conferencesRepository;
		$this->repositories[] = $this->hallsRepository;
		$this->repositories[] = $this->lecturebreaksRepository;
		$this->repositories[] = $this->lecturesparticipantsRepository;
		$this->repositories[] = $this->lecturesRepository;
		$this->repositories[] = $this->messagesRepository;
		$this->repositories[] = $this->notificationsRepository;
		$this->repositories[] = $this->rolesRepository;
		$this->repositories[] = $this->speakerinvitationsRepository;
		$this->repositories[] = $this->usersRepository;
		$this->repositories[] = $this->usersRolesRepository;
		$this->repositories[] = $this->venuereservationrequestsRepository;
		$this->repositories[] = $this->venuesRepository;
    }

    /**
     * @return \RedDevil\Repositories\ConferencesparticipantsRepository
     */
    public function getConferencesparticipantsRepository()
    {
        return $this->conferencesparticipantsRepository;
    }

    /**
     * @return \RedDevil\Repositories\ConferencesRepository
     */
    public function getConferencesRepository()
    {
        return $this->conferencesRepository;
    }

    /**
     * @return \RedDevil\Repositories\HallsRepository
     */
    public function getHallsRepository()
    {
        return $this->hallsRepository;
    }

    /**
     * @return \RedDevil\Repositories\LecturebreaksRepository
     */
    public function getLecturebreaksRepository()
    {
        return $this->lecturebreaksRepository;
    }

    /**
     * @return \RedDevil\Repositories\LecturesparticipantsRepository
     */
    public function getLecturesparticipantsRepository()
    {
        return $this->lecturesparticipantsRepository;
    }

    /**
     * @return \RedDevil\Repositories\LecturesRepository
     */
    public function getLecturesRepository()
    {
        return $this->lecturesRepository;
    }

    /**
     * @return \RedDevil\Repositories\MessagesRepository
     */
    public function getMessagesRepository()
    {
        return $this->messagesRepository;
    }

    /**
     * @return \RedDevil\Repositories\NotificationsRepository
     */
    public function getNotificationsRepository()
    {
        return $this->notificationsRepository;
    }

    /**
     * @return \RedDevil\Repositories\RolesRepository
     */
    public function getRolesRepository()
    {
        return $this->rolesRepository;
    }

    /**
     * @return \RedDevil\Repositories\SpeakerinvitationsRepository
     */
    public function getSpeakerinvitationsRepository()
    {
        return $this->speakerinvitationsRepository;
    }

    /**
     * @return \RedDevil\Repositories\UsersRepository
     */
    public function getUsersRepository()
    {
        return $this->usersRepository;
    }

    /**
     * @return \RedDevil\Repositories\UsersRolesRepository
     */
    public function getUsersRolesRepository()
    {
        return $this->usersRolesRepository;
    }

    /**
     * @return \RedDevil\Repositories\VenuereservationrequestsRepository
     */
    public function getVenuereservationrequestsRepository()
    {
        return $this->venuereservationrequestsRepository;
    }

    /**
     * @return \RedDevil\Repositories\VenuesRepository
     */
    public function getVenuesRepository()
    {
        return $this->venuesRepository;
    }

    /**
     * @param mixed $conferencesparticipantsRepository
     * @return $this
     */
    public function setConferencesparticipantsRepository($conferencesparticipantsRepository)
    {
        $this->conferencesparticipantsRepository = $conferencesparticipantsRepository;
        return $this;
    }

    /**
     * @param mixed $conferencesRepository
     * @return $this
     */
    public function setConferencesRepository($conferencesRepository)
    {
        $this->conferencesRepository = $conferencesRepository;
        return $this;
    }

    /**
     * @param mixed $hallsRepository
     * @return $this
     */
    public function setHallsRepository($hallsRepository)
    {
        $this->hallsRepository = $hallsRepository;
        return $this;
    }

    /**
     * @param mixed $lecturebreaksRepository
     * @return $this
     */
    public function setLecturebreaksRepository($lecturebreaksRepository)
    {
        $this->lecturebreaksRepository = $lecturebreaksRepository;
        return $this;
    }

    /**
     * @param mixed $lecturesparticipantsRepository
     * @return $this
     */
    public function setLecturesparticipantsRepository($lecturesparticipantsRepository)
    {
        $this->lecturesparticipantsRepository = $lecturesparticipantsRepository;
        return $this;
    }

    /**
     * @param mixed $lecturesRepository
     * @return $this
     */
    public function setLecturesRepository($lecturesRepository)
    {
        $this->lecturesRepository = $lecturesRepository;
        return $this;
    }

    /**
     * @param mixed $messagesRepository
     * @return $this
     */
    public function setMessagesRepository($messagesRepository)
    {
        $this->messagesRepository = $messagesRepository;
        return $this;
    }

    /**
     * @param mixed $notificationsRepository
     * @return $this
     */
    public function setNotificationsRepository($notificationsRepository)
    {
        $this->notificationsRepository = $notificationsRepository;
        return $this;
    }

    /**
     * @param mixed $rolesRepository
     * @return $this
     */
    public function setRolesRepository($rolesRepository)
    {
        $this->rolesRepository = $rolesRepository;
        return $this;
    }

    /**
     * @param mixed $speakerinvitationsRepository
     * @return $this
     */
    public function setSpeakerinvitationsRepository($speakerinvitationsRepository)
    {
        $this->speakerinvitationsRepository = $speakerinvitationsRepository;
        return $this;
    }

    /**
     * @param mixed $usersRepository
     * @return $this
     */
    public function setUsersRepository($usersRepository)
    {
        $this->usersRepository = $usersRepository;
        return $this;
    }

    /**
     * @param mixed $usersRolesRepository
     * @return $this
     */
    public function setUsersRolesRepository($usersRolesRepository)
    {
        $this->usersRolesRepository = $usersRolesRepository;
        return $this;
    }

    /**
     * @param mixed $venuereservationrequestsRepository
     * @return $this
     */
    public function setVenuereservationrequestsRepository($venuereservationrequestsRepository)
    {
        $this->venuereservationrequestsRepository = $venuereservationrequestsRepository;
        return $this;
    }

    /**
     * @param mixed $venuesRepository
     * @return $this
     */
    public function setVenuesRepository($venuesRepository)
    {
        $this->venuesRepository = $venuesRepository;
        return $this;
    }

    public function saveChanges()
    {
        foreach ($this->repositories as $repository) {
            $repositoryName = get_class($repository);
            $repositoryName::save();
        }
    }
}