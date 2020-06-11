<?php

use Nette\Application\UI\Presenter;

/**
 * Základní presenter, který je předkem všech dalších
 *
 * @author Jan Jíša <j.jisa@seznam.cz>
 * @package Workity
 */
abstract class BasePresenter extends Presenter {

    /**
     * @var \DibiConnection 
     */
    protected $databaseConnection;

    /**
     * @var \Workity\Repositories\CommonRepository
     */
    protected $commonRepository;

    /**
     * @var \Workity\Repositories\HomepageRepository
     */
    protected $homepageRepository;

    /**
     * @var \Workity\Repositories\NotificatorRepository
     */
    protected $notificatorRepositoy;

    /**
     * @var \Workity\Repositories\UserRepository 
     */
    protected $userRepository;

    /**
     * @var \Workity\Repositories\EventRepository
     */
    protected $eventRepository;

    /**
     * @var \Workity\Repositories\EventVisibilityRepository 
     */
    protected $eventVisibilityRepository;

    /**
     * @var \Workity\Repositories\ProjectRepository 
     */
    protected $projectRepository;

    /**
     * @var \Workity\Repositories\TaskRepository
     */
    protected $taskRepository;

    /**
     * @var \Workity\Repositories\FileRepository
     */
    protected $fileRepository;

    /**
     * @var \Workity\Repositories\EmailRepository
     */
    protected $emailRepository;

    /**
     * @var \Workity\Repositories\UserGroupRepository
     */
    protected $userGroupRepository;

    /**
     * @var \Workity\Repositories\UserAccountStatusRepository
     */
    protected $userAccountStatusRepository;

    /**
     * @var \Workity\Repositories\CustomerRepository
     */
    protected $customerRepository;

    /**
     * @var \Workity\Repositories\PriorityRepository
     */
    protected $priorityRepository;

    /**
     * @var \Workity\Repositories\TokenRepository
     */
    protected $tokenRepository;

    protected function startup() {
        parent::startup();

        // pokud neexistuje soubor installed, nainstaluj aplikaci
        if (!file_exists(APP_BASE_DIR . "/config/installed")) {
            $this->redirect("Install:");
        }

        $this->databaseConnection = $this->context->dibi->connection;
    }

    /**
     * Metoda injektující modely pro celou aplikaci
     * @param \Workity\Repositories\UserRepository $userRepository
     * @param \Workity\Repositories\EventRepository $eventRepository
     * @param \Workity\Repositories\EventVisibilityRepository $eventVisibilityRepository
     * @param \Workity\Repositories\ProjectRepository  $projectRepository 
     * @param \Workity\Repositories\TaskRepository  $taskRepository 
     * @param \Workity\Repositories\FileRepository  $fileRepository
     * @param \Workity\Repositories\EmailRepository $emailRepository
     * @param \Workity\Repositories\UserGroupRepository $userGroupRepository
     * @param \Workity\Repositories\UserAccountStatusRepository $userAccountStatusRepository
     * @param \Workity\Repositories\CustomerRepository $customerRepository
     * @param \Workity\Repositories\PriorityRepository $priorityRepository
     * @param \Workity\Repositories\CommonRepository $commonRepository
     * @param \Workity\Repositories\TokenRepository $tokenRepository
     * @param \Workity\Repositories\HomepageRepository $homepageRepository
     * @param \Workity\Repositories\NotificatorRepository $notificatoRepository
     */
    public function injectBaseModels(
    \Workity\Repositories\UserRepository $userRepository
    , \Workity\Repositories\EventRepository $eventRepository
    , \Workity\Repositories\EventVisibilityRepository $eventVisibilityRepository
    , \Workity\Repositories\ProjectRepository $projectRepository
    , \Workity\Repositories\TaskRepository $taskRepository
    , \Workity\Repositories\FileRepository $fileRepository
    , \Workity\Repositories\EmailRepository $emailRepository
    , \Workity\Repositories\UserGroupRepository $userGroupRepository
    , \Workity\Repositories\UserAccountStatusRepository $userAccountStatusRepository
    , \Workity\Repositories\CustomerRepository $customerRepository
    , \Workity\Repositories\PriorityRepository $priorityRepository
    , \Workity\Repositories\CommonRepository $commonRepository
    , \Workity\Repositories\TokenRepository $tokenRepository
    , \Workity\Repositories\HomepageRepository $homepageRepository
    , \Workity\Repositories\NotificatorRepository $notificatorRepository
    ) {
        $this->userRepository = $userRepository;
        $this->eventRepository = $eventRepository;
        $this->eventVisibilityRepository = $eventVisibilityRepository;
        $this->projectRepository = $projectRepository;
        $this->taskRepository = $taskRepository;
        $this->fileRepository = $fileRepository;
        $this->emailRepository = $emailRepository;
        $this->userGroupRepository = $userGroupRepository;
        $this->userAccountStatusRepository = $userAccountStatusRepository;
        $this->customerRepository = $customerRepository;
        $this->priorityRepository = $priorityRepository;
        $this->commonRepository = $commonRepository;
        $this->tokenRepository = $tokenRepository;
        $this->homepageRepository = $homepageRepository;
        $this->notificatorRepositoy = $notificatorRepository;
    }

    /**
     * Výpis společných prvků aplikace 
     */
    public function beforeRender() {
        parent::beforeRender();

        // Odkazy v patičce
        $this->template->footerLinks = array(
//            "Nápověda" => "Help:",
            "Licence" => "License:",
            "Nahlásit chybu" => "ReportIssue:"
        );

        // Copyright rok
        $this->template->copyrightYear = $this->commonRepository->getCopyrightYear();
    }

}

?>
