<?php

namespace Orakulas\ModelBundle\Controller;

use \Orakulas\ModelBundle\Controller\DefaultController;
use \Orakulas\ModelBundle\Facades\UserFacade;

class UserController extends DefaultController {

    public function getEntityFacade() {
        $entityFacade = parent::getEntityFacade();

        if ($entityFacade == NULL) {
            $entityFacade = new UserFacade();
            $entityFacade->setDoctrine($this->getDoctrine());
            $entityFacade->setEncoderFactory($this->get('security.encoder_factory'));

            parent::setEntityFacade($entityFacade);
        }

        return $entityFacade;
    }

    public function currentUserAction() {
        $user = $this->get('security.context')->getToken()->getUser();
        $associativeUserArray = $this->getEntityFacade()->toArray($user);

        $jsonUser = json_encode($associativeUserArray);

        return $this->constructResponse($jsonUser);
    }

}
