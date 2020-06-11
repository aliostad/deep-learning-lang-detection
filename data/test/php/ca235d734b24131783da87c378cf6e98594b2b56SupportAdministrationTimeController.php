<?php

namespace Orakulas\ModelBundle\Controller;

use \Orakulas\ModelBundle\Controller\DefaultController;
use \Orakulas\ModelBundle\Facades\SupportAdministrationTimeFacade;
use \Orakulas\ModelBundle\Facades\DepartmentFacade;
use \Orakulas\ModelBundle\Facades\SupportTypeFacade;
use \Orakulas\ModelBundle\Facades\SupportCategoryFacade;

class SupportAdministrationTimeController extends DefaultController {

    public function getEntityFacade() {
        $entityFacade = parent::getEntityFacade();

        if ($entityFacade == NULL) {
            $entityFacade = new SupportAdministrationTimeFacade();
            $departmentFacade = new DepartmentFacade();
            $supportTypeFacade = new SupportTypeFacade();
            $supportCategoryFacade = new SupportCategoryFacade();

            $entityFacade->setDoctrine($this->getDoctrine());
            $departmentFacade->setDoctrine($this->getDoctrine());
            $supportTypeFacade->setDoctrine($this->getDoctrine());
            $supportCategoryFacade->setDoctrine($this->getDoctrine());

            $supportTypeFacade->setSupportCategoryFacade($supportCategoryFacade);
            $entityFacade->setDepartmentFacade($departmentFacade);
            $entityFacade->setSupportTypeFacade($supportTypeFacade);

            parent::setEntityFacade($entityFacade);
        }

        return $entityFacade;
    }

}
