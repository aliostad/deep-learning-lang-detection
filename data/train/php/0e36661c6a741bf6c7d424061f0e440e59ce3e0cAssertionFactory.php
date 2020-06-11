<?php
/**
 * ARTEMIS-IA copyright message placeholder.
 *
 * @category Content
 *
 * @author    Andre Hebben <andre.hebben@artemis-ia.eu>
 * @copyright Copyright (c) 2008-2016 ARTEMIS-IA (http://artemis-ia.eu)
 */

namespace Project\Acl\Factory;

use Affiliation\Service\AffiliationService;
use General\Service\GeneralService;
use Interop\Container\ContainerInterface;
use Program\Service\CallService;
use Project\Service\AchievementService;
use Project\Service\DocumentService;
use Project\Service\EvaluationService;
use Project\Service\HelpService;
use Project\Service\IdeaService;
use Project\Service\InviteService;
use Project\Service\ProjectService;
use Project\Service\RoomService;
use Project\Service\VersionService;
use Zend\Mvc\Application;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;
use Admin\Service\AdminService;
use Contact\Service\ContactService;
use Project\Acl\Assertion\AbstractAssertion;

/**
 * Class AssertionFactory
 * @package Project\Acl\Factory
 */
final class AssertionFactory implements FactoryInterface
{
    /**
     * @param ContainerInterface|ServiceManager     $container
     * @param                                       $requestedName
     * @param array|null                            $options
     *
     * @return AbstractAssertion
     */
    public function __invoke(ServiceManager $container, $requestedName, array $options = null)
    {
        /** @var $assertion AbstractAssertion */
        $assertion = new $requestedName($options);
        $assertion->setServiceLocator($container);

        /** @var Application $application */
        $application = $container->get('Application');
        $assertion->setApplication($application);

        /** @var AdminService $adminService */
        $adminService = $container->get(AdminService::class);
        $assertion->setAdminService($adminService);

        /** @var ContactService $contactService */
        $contactService = $container->get(ContactService::class);
        /** @var AuthenticationService $authenticationService */
        $authenticationService = $container->get('zfcuser_auth_service');
        if ($authenticationService->hasIdentity()) {
            $contactService->setContact($authenticationService->getIdentity());
        }
        $assertion->setContactService($contactService);

        /** @var VersionService $versionService */
        $versionService = $container->get(VersionService::class);
        $assertion->setVersionService($versionService);

        /** @var EvaluationService $evaluationService */
        $evaluationService = $container->get(EvaluationService::class);
        $assertion->setEvaluationService($evaluationService);

        /** @var IdeaService $ideaService */
        $ideaService = $container->get(IdeaService::class);
        $assertion->setIdeaService($ideaService);

        /** @var RoomService $roomService */
        $roomService = $container->get(RoomService::class);
        $assertion->setRoomService($roomService);

        /** @var InviteService $inviteService */
        $inviteService = $container->get(InviteService::class);
        $assertion->setInviteService($inviteService);

        /** @var AchievementService $achievementService */
        $achievementService = $container->get(AchievementService::class);
        $assertion->setAchievementService($achievementService);

        /** @var ProjectService $projectService */
        $projectService = $container->get(ProjectService::class);
        $assertion->setProjectService($projectService);

        /** @var CallService $callService */
        $callService = $container->get(CallService::class);
        $assertion->setCallService($callService);

        /** @var AffiliationService $affiliationService */
        $affiliationService = $container->get(AffiliationService::class);
        $assertion->setAffiliationService($affiliationService);

        /** @var DocumentService $documentService */
        $documentService = $container->get(DocumentService::class);
        $assertion->setDocumentService($documentService);

        /** @var GeneralService $generalService */
        $generalService = $container->get(GeneralService::class);
        $assertion->setGeneralService($generalService);

        /** @var HelpService $helpService */
        $helpService = $container->get(HelpService::class);
        $assertion->setHelpService($helpService);

        return $assertion;
    }

    /**
     * @param ServiceLocatorInterface $container
     * @param null                    $canonicalName
     * @param string                  $requestedName
     *
     * @return AbstractAssertion
     */
    public function createService(ServiceLocatorInterface $container, $canonicalName = null, $requestedName = null)
    {
        return $this($container, $requestedName);
    }
}
