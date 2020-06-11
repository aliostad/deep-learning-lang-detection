<?php

namespace Orakulas\ModelBundle\Controller;

use \Orakulas\ModelBundle\Controller\DefaultController;
use \Orakulas\ModelBundle\Facades\DepartmentInfoSysUsageFacade;
use \Orakulas\ModelBundle\Facades\DepartmentFacade;
use \Orakulas\ModelBundle\Facades\InformationalSystemFacade;

class DepartmentInfoSysUsageController extends DefaultController {

    public function getEntityFacade() {
        $entityFacade = parent::getEntityFacade();

        if ($entityFacade == NULL) {
            $entityFacade = new DepartmentInfoSysUsageFacade();
            $departmentFacade = new DepartmentFacade();
            $informationalSystemFacade = new InformationalSystemFacade();

            $entityFacade->setDoctrine($this->getDoctrine());
            $departmentFacade->setDoctrine($this->getDoctrine());
            $informationalSystemFacade->setDoctrine($this->getDoctrine());

            $entityFacade->setDepartmentFacade($departmentFacade);
            $entityFacade->setInformationalSystemFacade($informationalSystemFacade);

            parent::setEntityFacade($entityFacade);
        }

        return $entityFacade;
    }

}
