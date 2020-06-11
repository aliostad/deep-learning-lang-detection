<?php
/**
 * ARTEMIS-IA Office copyright message placeholder.
 *
 * @category  Calendar
 *
 * @author    Andre Hebben <andre.hebben@artemis-ia.eu>
 * @copyright Copyright (c) 2008-2016 ARTEMIS-IA Office (https://artemis-ia.eu)
 */

namespace Calendar\Controller;

use BjyAuthorize\Controller\Plugin\IsAllowed;
use Calendar\Service\CalendarService;
use Calendar\Service\FormService;
use Contact\Service\ContactService;
use General\Service\EmailService;
use General\Service\GeneralService;
use Project\Service\ProjectService;
use Project\Service\WorkpackageService;
use Zend\Mvc\Controller\AbstractActionController;
use Zend\Mvc\Controller\Plugin\FlashMessenger;
use ZfcUser\Controller\Plugin\ZfcUserAuthentication;

/**
 * @method      ZfcUserAuthentication zfcUserAuthentication()
 * @method      FlashMessenger flashMessenger()
 * @method      isAllowed isAllowed($resource, $action)
 */
abstract class AbstractController extends AbstractActionController
{
    /** @var FormService */
    protected $formService;

    /** @var CalendarService; */
    protected $calendarService;

    /** @var GeneralService */
    protected $generalService;

    /** @var ContactService */
    protected $contactService;

    /** @var EmailService */
    protected $emailService;

    /** @var ProjectService */
    protected $projectService;

    /** @var WorkpackageService */
    protected $workpackageService;

    /**
     * @return FormService
     */
    public function getFormService()
    {
        return $this->formService;
    }

    /**
     * @param FormService $formService
     * @return AbstractController
     */
    public function setFormService(FormService $formService)
    {
        $this->formService = $formService;
        return $this;
    }

    /**
     * @return CalendarService
     */
    public function getCalendarService()
    {
        return $this->calendarService;
    }

    /**
     * @param CalendarService $calendarService
     * @return AbstractController
     */
    public function setCalendarService(CalendarService $calendarService)
    {
        $this->calendarService = $calendarService;
        return $this;
    }

    /**
     * @return GeneralService
     */
    public function getGeneralService()
    {
        return $this->generalService;
    }

    /**
     * @param GeneralService $generalService
     * @return AbstractController
     */
    public function setGeneralService(GeneralService $generalService)
    {
        $this->generalService = $generalService;
        return $this;
    }

    /**
     * @return ContactService
     */
    public function getContactService()
    {
        return $this->contactService;
    }

    /**
     * @param ContactService $contactService
     * @return AbstractController
     */
    public function setContactService(ContactService $contactService)
    {
        $this->contactService = $contactService;
        return $this;
    }

    /**
     * @return EmailService
     */
    public function getEmailService()
    {
        return $this->emailService;
    }

    /**
     * @param EmailService $emailService
     * @return AbstractController
     */
    public function setEmailService(EmailService $emailService)
    {
        $this->emailService = $emailService;
        return $this;
    }

    /**
     * @return ProjectService
     */
    public function getProjectService()
    {
        return $this->projectService;
    }

    /**
     * @param ProjectService $projectService
     * @return AbstractController
     */
    public function setProjectService(ProjectService $projectService)
    {
        $this->projectService = $projectService;
        return $this;
    }

    /**
     * @return WorkpackageService
     */
    public function getWorkpackageService()
    {
        return $this->workpackageService;
    }

    /**
     * @param WorkpackageService $workpackageService
     * @return AbstractController
     */
    public function setWorkpackageService(WorkpackageService $workpackageService)
    {
        $this->workpackageService = $workpackageService;
        return $this;
    }
}
