<?php
/**
 * ITEA Office all rights reserved
 *
 * @category    Contact
 *
 * @author      Johan van der Heide <johan.van.der.heide@itea3.org>
 * @copyright   Copyright (c) 2004-2017 ITEA Office (https://itea3.org)
 */

declare(strict_types=1);

namespace Contact\Service;

use Admin\Service\AdminService;
use Contact\Entity\Contact;
use Contact\Entity\EntityAbstract;
use Contact\Entity\Selection;
use Contact\Options\ModuleOptions;
use Contact\Search\Service\ContactSearchService;
use Contact\Search\Service\ProfileSearchService;
use Deeplink\Service\DeeplinkService;
use Doctrine\ORM\AbstractQuery;
use Doctrine\ORM\Query;
use Event\Service\MeetingService;
use General\Service\EmailService;
use General\Service\GeneralService;
use Interop\Container\ContainerInterface;
use Organisation\Service\OrganisationService;
use Project\Service\ProjectService;
use Zend\ServiceManager\ServiceLocatorInterface;
use ZfcUser\Options\UserServiceOptionsInterface;

/**
 * ServiceAbstract.
 */
abstract class ServiceAbstract implements ServiceInterface
{
    /**
     * @var \Doctrine\ORM\EntityManager
     */
    protected $entityManager;
    /**
     * @var ServiceLocatorInterface
     */
    protected $serviceLocator;
    /**
     * @var ModuleOptions
     */
    protected $moduleOptions;
    /**
     * @var DeeplinkService
     */
    protected $deeplinkService;
    /**
     * @var ProjectService
     */
    protected $projectService;
    /**
     * @var ContactService
     */
    protected $contactService;
    /**
     * @var SelectionService
     */
    protected $selectionService;
    /**
     * @var MeetingService
     */
    protected $meetingService;
    /**
     * @var OrganisationService
     */
    protected $organisationService;
    /**
     * @var GeneralService
     */
    protected $generalService;
    /**
     * @var EmailService
     */
    protected $emailService;
    /**
     * @var AdminService
     */
    protected $adminService;
    /**
     * @var AddressService
     */
    protected $addressService;
    /**
     * @var UserServiceOptionsInterface
     */
    protected $zfcUserOptions;


    /**
     * @param   $entity
     *
     * @return \Contact\Entity\OptIn[]
     */
    public function findAll($entity)
    {
        return $this->getEntityManager()->getRepository($entity)->findAll();
    }

    /**
     * @return \Doctrine\ORM\EntityManager
     */
    public function getEntityManager(): \Doctrine\ORM\EntityManager
    {
        return $this->entityManager;
    }

    /**
     * @param \Doctrine\ORM\EntityManager $entityManager
     *
     * @return ServiceAbstract
     */
    public function setEntityManager($entityManager)
    {
        $this->entityManager = $entityManager;

        return $this;
    }

    /**
     * @param string $entity
     * @param        $filter
     *
     * @return Query
     */
    public function findEntitiesFiltered($entity, $filter)
    {
        $equipmentList = $this->getEntityManager()->getRepository($entity)
            ->findFiltered($filter, AbstractQuery::HYDRATE_SIMPLEOBJECT);

        return $equipmentList;
    }

    /**
     * Find 1 entity based on the id.
     *
     * @param string $entity
     * @param        $id
     *
     * @return null|Contact|Selection
     */
    public function findEntityById($entity, $id)
    {
        return $this->getEntityManager()->find($entity, $id);
    }

    /**
     * @param EntityAbstract $entity
     *
     * @return EntityAbstract
     */
    public function newEntity(EntityAbstract $entity)
    {
        return $this->updateEntity($entity);
    }

    /**
     * @param EntityAbstract $entity
     *
     * @return EntityAbstract
     */
    public function updateEntity(EntityAbstract $entity)
    {
        $this->getEntityManager()->persist($entity);
        $this->getEntityManager()->flush();

        // Update the search engine after contact update
        if ($entity instanceof Contact) {
            /** @var ProfileSearchService $profileSearchService */
            $profileSearchService = $this->getServiceLocator()->get(ProfileSearchService::class);
            /** @var Contact $entity */
            $profileSearchService->updateDocument($entity);
            /** @var ContactSearchService $contactSearchService */
            $contactSearchService = $this->getServiceLocator()->get(ContactSearchService::class);
            $contactSearchService->updateDocument($entity);
        }

        return $entity;
    }

    /**
     * @param EntityAbstract $entity
     *
     * @return bool
     */
    public function removeEntity(EntityAbstract $entity)
    {
        $this->getEntityManager()->remove($entity);
        $this->getEntityManager()->flush();

        return true;
    }

    /**
     * @return ModuleOptions
     */
    public function getModuleOptions()
    {
        return $this->moduleOptions;
    }

    /**
     * @param ModuleOptions $moduleOptions
     *
     * @return ServiceAbstract
     */
    public function setModuleOptions($moduleOptions)
    {
        $this->moduleOptions = $moduleOptions;

        return $this;
    }

    /**
     * @return DeeplinkService
     */
    public function getDeeplinkService()
    {
        return $this->deeplinkService;
    }

    /**
     * @param DeeplinkService $deeplinkService
     *
     * @return ServiceAbstract
     */
    public function setDeeplinkService($deeplinkService)
    {
        $this->deeplinkService = $deeplinkService;

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
     *
     * @return ServiceAbstract
     */
    public function setProjectService($projectService)
    {
        $this->projectService = $projectService;

        return $this;
    }

    /**
     * @return SelectionService
     */
    public function getSelectionService()
    {
        return $this->selectionService;
    }

    /**
     * @param SelectionService $selectionService
     *
     * @return ServiceAbstract
     */
    public function setSelectionService($selectionService)
    {
        $this->selectionService = $selectionService;

        return $this;
    }

    /**
     * @return MeetingService
     */
    public function getMeetingService()
    {
        if (is_null($this->meetingService)) {
            $this->meetingService = $this->getServiceLocator()->get(MeetingService::class);
        }

        return $this->meetingService;
    }

    /**
     * @param MeetingService $meetingService
     *
     * @return ServiceAbstract
     */
    public function setMeetingService($meetingService)
    {
        $this->meetingService = $meetingService;

        return $this;
    }

    /**
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    /**
     * @param ServiceLocatorInterface|ContainerInterface $serviceLocator
     *
     * @return ServiceAbstract
     */
    public function setServiceLocator($serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;

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
     * @param OrganisationService $organisationService
     *
     * @return ServiceAbstract
     */
    public function setOrganisationService($organisationService)
    {
        $this->organisationService = $organisationService;

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
     *
     * @return ServiceAbstract
     */
    public function setGeneralService($generalService)
    {
        $this->generalService = $generalService;

        return $this;
    }

    /**
     * @return EmailService
     */
    public function getEmailService()
    {
        if (is_null($this->emailService)) {
            $this->emailService = $this->getServiceLocator()->get(EmailService::class);
        }

        return $this->emailService;
    }

    /**
     * @param EmailService $emailService
     *
     * @return ServiceAbstract
     */
    public function setEmailService($emailService)
    {
        $this->emailService = $emailService;

        return $this;
    }

    /**
     * @return AdminService
     */
    public function getAdminService()
    {
        return $this->adminService;
    }

    /**
     * @param AdminService $adminService
     *
     * @return ServiceAbstract
     */
    public function setAdminService($adminService)
    {
        $this->adminService = $adminService;

        return $this;
    }

    /**
     * @return AddressService
     */
    public function getAddressService()
    {
        return $this->addressService;
    }

    /**
     * @param AddressService $addressService
     *
     * @return ServiceAbstract
     */
    public function setAddressService($addressService)
    {
        $this->addressService = $addressService;

        return $this;
    }

    /**
     * @return UserServiceOptionsInterface
     */
    public function getZfcUserOptions()
    {
        return $this->zfcUserOptions;
    }

    /**
     * @param UserServiceOptionsInterface $zfcUserOptions
     *
     * @return ServiceAbstract
     */
    public function setZfcUserOptions($zfcUserOptions)
    {
        $this->zfcUserOptions = $zfcUserOptions;

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
     *
     * @return ServiceAbstract
     */
    public function setContactService($contactService)
    {
        $this->contactService = $contactService;

        return $this;
    }
}
