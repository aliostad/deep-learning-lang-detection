<?php
/**
 * ARTEMIS-IA Office copyright message placeholder.
 *
 * @category   Program
 *
 * @author     Andre Hebben <andre.hebben@artemis-ia.eu>
 * @copyright  2007-2015 ARTEMIS-IA Office
 * @license    http://debranova.org/license.txt proprietary
 *
 * @link       http://debranova.org
 */

namespace Program\Controller;

use Contact\Service\ContactService;
use General\Service\GeneralService;
use Organisation\Service\OrganisationService;
use Program\Options\ModuleOptions;
use Program\Service\CallService;
use Program\Service\FormService;
use Program\Service\ProgramService;
use Zend\I18n\View\Helper\Translate;
use Zend\Mvc\Controller\AbstractActionController;

/**
 * Class AbstractController
 * @package Program\Controller
 */
abstract class AbstractController extends AbstractActionController
{
    /** @var ProgramService */
    protected $programService;

    /** @var GeneralService */
    protected $generalService;

    /** @var CallService */
    protected $callService;

    /** @var ContactService */
    protected $contactService;

    /** @var OrganisationService */
    protected $organisationService;

    /** @var FormService */
    protected $formService;

    /** @var ModuleOptions */
    protected $moduleOptions;

    /** @var Translate */
    protected $translationHelper;

    /**
     * @return FormService
     */
    public function getFormService()
    {
        return $this->formService;
    }

    /**
     * @param $formService
     *
     * @return AbstractController
     */
    public function setFormService($formService)
    {
        $this->formService = $formService;

        return $this;
    }

    /**
     * Gateway to the Program Service.
     *
     * @return ProgramService
     */
    public function getProgramService()
    {
        return $this->programService;
    }

    /**
     * @param $programService
     *
     * @return AbstractController
     */
    public function setProgramService(ProgramService $programService)
    {
        $this->programService = $programService;

        return $this;
    }

    /**
     * Gateway to the Call Service.
     *
     * @return CallService
     */
    public function getCallService()
    {
        return $this->callService;
    }

    /**
     * @param $callService
     *
     * @return AbstractController
     */
    public function setCallService(CallService $callService)
    {
        $this->callService = $callService;

        return $this;
    }

    /**
     * Gateway to the General Service.
     *
     * @return GeneralService
     */
    public function getGeneralService()
    {
        return $this->generalService;
    }

    /**
     * @param $generalService
     *
     * @return AbstractController
     */
    public function setGeneralService(GeneralService $generalService)
    {
        $this->generalService = $generalService;

        return $this;
    }

    /**
     * @return ModuleOptions
     */
    public function getModuleOptions()
    {
        return $this->getServiceLocator()->get(ModuleOptions::class);
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
     *
     * @return $this;
     */
    public function setContactService(ContactService $contactService)
    {
        $this->contactService = $contactService;

        return $this;
    }

    /**
     * @return OrganisationService
     */
    public function getOrganisationService()
    {
        return $this->organisationService;
    }

    /**
     * @param  OrganisationService       $organisationService
     * @return AbstractController
     */
    public function setOrganisationService(OrganisationService $organisationService)
    {
        $this->organisationService = $organisationService;

        return $this;
    }

    /**
     * @return Translate
     */
    public function getTranslationHelper()
    {
        return $this->translationHelper;
    }

    /**
     * @param Translate $translationHelper
     * @return AbstractController
     */
    public function setTranslationHelper(Translate $translationHelper)
    {
        $this->translationHelper = $translationHelper;
        return $this;
    }

    /**
     * Translate a string
     * @param $string
     * @return string
     */
    protected function translate($string)
    {
        $translator = $this->getTranslationHelper();
        return $translator ? $translator($string) : $string;
    }
}
