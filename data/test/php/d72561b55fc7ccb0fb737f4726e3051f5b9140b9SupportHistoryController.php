<?php

namespace Orakulas\ModelBundle\Controller;

use \Orakulas\ModelBundle\Controller\DefaultController;
use \Orakulas\ModelBundle\Facades\SupportHistoryFacade;
use \Orakulas\ModelBundle\Facades\SupportTypeFacade;
use \Orakulas\ModelBundle\Facades\SupportCategoryFacade;

class SupportHistoryController extends DefaultController {

    public function getEntityFacade() {
        $entityFacade = parent::getEntityFacade();

        if ($entityFacade == NULL) {
            $entityFacade = new SupportHistoryFacade();
            $supportTypeFacade = new SupportTypeFacade();
            $supportCategoryFacade = new SupportCategoryFacade();

            $entityFacade->setDoctrine($this->getDoctrine());
            $supportTypeFacade->setDoctrine($this->getDoctrine());
            $supportCategoryFacade->setDoctrine($this->getDoctrine());

            $supportTypeFacade->setSupportCategoryFacade($supportCategoryFacade);
            $entityFacade->setSupportTypeFacade($supportTypeFacade);

            parent::setEntityFacade($entityFacade);
        }

        return $entityFacade;
    }

    public function importAction() {
        $responseArray = array('success' => true);

        try {
            $this->getEntityFacade()->import($_POST["jsonValue"]);
        } catch (\Exception $e) {
            $responseArray['success'] = false;
        }

        return $this->constructResponse(json_encode($responseArray));
    }

}
