<?php

namespace Orakulas\ModelBundle\Facades;

use \Orakulas\ModelBundle\Facades\EntityFacade;
use \Orakulas\ModelBundle\Entity\SupportAdministrationTime;
use \Orakulas\ModelBundle\Facades\DepartmentFacade;
use \Orakulas\ModelBundle\Facades\SupportTypeFacade;

class SupportAdministrationTimeFacade extends EntityFacade {

    const SUPPORT_ADMINISTRATION_TIME = 'SupportAdministrationTime';

    /**
     * @var \Orakulas\ModelBundle\Facades\DepartmentFacade
     */
    private $departmentFacade;

    /**
     * @var \Orakulas\ModelBundle\Facades\SupportTypeFacade
     */
    private $supportTypeFacade;

    /**
     * @param int $id
     * @return \Orakulas\ModelBundle\Entity\SupportAdministrationTime
     */
     public function load($id) {
         if ($id == NULL) {
             throw new \InvalidArgumentException('parameter $id and cannot be null');
         }

         if ($this->getDoctrine() == NULL) {
             throw new EntityFacadeException('doctrine isn\'t set');
         }

         $repository = $this->getDoctrine()->getRepository(UserFacade::BUNDLE_NAME.':'.SupportAdministrationTimeFacade::SUPPORT_ADMINISTRATION_TIME);
         $entity = $repository->find($id);

         return $entity;
     }

     /**
      * @return array
      */
     public function loadAll() {
         if ($this->getDoctrine() == NULL) {
             throw new EntityFacadeException('doctrine isn\'t set');
         }

         $repository = $this->getDoctrine()->getRepository(UserFacade::BUNDLE_NAME.':'.SupportAdministrationTimeFacade::SUPPORT_ADMINISTRATION_TIME);
         return $repository->findAll();
     }

    /**
     * @param \Orakulas\ModelBundle\Entity\SupportAdministrationTime $entity
     * @return array
     */
    public function toArray($entity) {
        $array = array(
            'id'          => $entity->getId(),
            'hoursCount'  => $entity->getHoursCount(),
            'department'  => $this->getDepartmentFacade()->toSimpleArray($entity->getDepartment()),
            'supportType' => $this->getSupportTypeFacade()->toSimpleArray($entity->getSupportType())
        );

        return $array;
    }

    /**
     * @param array $array
     * @return \Orakulas\ModelBundle\Entity\SupportAdministrationTime
     */
    public function fromArray($array) {
        $supportAdministrationTime = new SupportAdministrationTime();

        if (isset($array['id']))
            $supportAdministrationTime->setId($array['id']);
        if (isset($array['hoursCount']))
            $supportAdministrationTime->setHoursCount($array['hoursCount']);

        if (isset($array['department'])) {
            $department = null;

            if (is_array($array['department']))
                $department = $this->getDepartmentFacade()->fromArray($array['department']);
            else
                $department = $this->getDepartmentFacade()->load((int) $array['department']);

            $supportAdministrationTime->setDepartment($department);
        }

        if (isset($array['supportType'])) {
            $supportType = null;

            if (is_array($array['supportType']))
                $supportType = $this->getSupportTypeFacade()->fromArray($array['supportType']);
            else
                $supportType = $this->getSupportTypeFacade()->load($array['supportType']);

            $supportAdministrationTime->setSupportType($supportType);
        }

        return $supportAdministrationTime;
    }

    /**
     * @param array $source
     * @param \Orakulas\ModelBundle\Entity\SupportAdministrationTime $destination
     */
    public function merge($destination, $source) {
        if (isset($source['hoursCount']))
            $destination->setHoursCount($source['hoursCount']);

        if (isset($source['department'])) {
            $department = null;

            if (is_array($source['department']))
                $department = $this->getDepartmentFacade()->fromArray($source['department']);
            else
                $department = $this->getDepartmentFacade()->load((int) $source['department']);

            $destination->setDepartment($department);
        }

        if (isset($source['supportType'])) {
            $supportType = null;

            if (is_array($source['supportType']))
                $supportType = $this->getSupportTypeFacade()->fromArray($source['supportType']);
            else
                $supportType = $this->getSupportTypeFacade()->load($source['supportType']);

            $destination->setSupportType($supportType);
        }
    }

    /**
     * @param \Orakulas\ModelBundle\Facades\DepartmentFacade $departmentFacade
     */
    public function setDepartmentFacade($departmentFacade)
    {
        $this->departmentFacade = $departmentFacade;
    }

    /**
     * @return \Orakulas\ModelBundle\Facades\DepartmentFacade
     */
    public function getDepartmentFacade()
    {
        return $this->departmentFacade;
    }

    /**
     * @param \Orakulas\ModelBundle\Facades\SupportTypeFacade $supportTypeFacade
     */
    public function setSupportTypeFacade($supportTypeFacade)
    {
        $this->supportTypeFacade = $supportTypeFacade;
    }

    /**
     * @return \Orakulas\ModelBundle\Facades\SupportTypeFacade
     */
    public function getSupportTypeFacade()
    {
        return $this->supportTypeFacade;
    }
}
