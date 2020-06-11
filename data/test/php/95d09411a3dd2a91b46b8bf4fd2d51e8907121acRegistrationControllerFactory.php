<?php
namespace NapierManagementTraining\V1\Rpc\Registration;

class RegistrationControllerFactory
{
    public function __invoke($controllers)
    {
        $em = $controllers->getServiceLocator()->get('Doctrine\ORM\EntityManager');
        $usersRepository = $em->getRepository('Application\Entity\Users');
        $sessionsRepository = $em->getRepository('Application\Entity\Sessions');
        $titlesRepository = $em->getRepository('Application\Entity\Titles');
        return new RegistrationController($em, $usersRepository, $sessionsRepository, $titlesRepository);
    }
}
