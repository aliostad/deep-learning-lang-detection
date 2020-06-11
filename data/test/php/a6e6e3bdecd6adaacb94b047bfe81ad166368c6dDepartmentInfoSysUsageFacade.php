<?php

namespace Orakulas\ModelBundle\Facades;

use \Orakulas\ModelBundle\Facades\EntityFacade;
use \Orakulas\ModelBundle\Facades\DepartmentFacade;
use \Orakulas\ModelBundle\Facades\InformationalSystemFacade;
use \Orakulas\ModelBundle\Entity\DepartmentInfoSysUsage;

class DepartmentInfoSysUsageFacade extends EntityFacade {

    const DEPARTMENT_INFO_SYS_USAGE = 'DepartmentInfoSysUsage';

    /**
     * @var \Orakulas\ModelBundle\Facades\DepartmentFacade
     */
    private $departmentFacade;

    /**
     * @var \Orakulas\ModelBundle\Facades\InformationalSystemFacade
     */
    private $informationalSystemFacade;

    /**
     * @param int $id
     * @return \Orakulas\ModelBundle\Entity\DepartmentInfoSysUsage
     */
     public function load($id) {
         if ($id == NULL) {
             throw new \InvalidArgumentException('parameter $id and cannot be null');
         }

         if ($this->getDoctrine() == NULL) {
             throw new EntityFacadeException('doctrine isn\'t set');
         }

         $repository = $this->getDoctrine()->getRepository(UserFacade::BUNDLE_NAME.':'.DepartmentInfoSysUsageFacade::DEPARTMENT_INFO_SYS_USAGE);
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

         $repository = $this->getDoctrine()->getRepository(UserFacade::BUNDLE_NAME.':'.DepartmentInfoSysUsageFacade::DEPARTMENT_INFO_SYS_USAGE);
         return $repository->findAll();
     }

    /**
     * @param \Orakulas\ModelBundle\Entity\DepartmentInfoSysUsage $entity
     * @return array
     */
    public function toArray($entity) {
        $array = array(
            'id'   => $entity->getId(),
            'department' => $this->getDepartmentFacade()->toArray($entity->getDepartment()),
            'informationalSystem' => $this->getInformationalSystemFacade()->toArray($entity->getInformationalSystem())
        );

        return $array;
    }

    /**
     * @param array $array
     * @return Orakulas\ModelBundle\Entity\DepartmentInfoSysUsage
     */
    public function fromArray($array) {
        $departmentInfoSysUsage = new DepartmentInfoSysUsage();

        if (isset($array['id']))
            $departmentInfoSysUsage->setId($array['id']);

        if (isset($array['department'])) {
            $department = null;

            if (is_array($array['department']))
                $department = $this->getDepartmentFacade()->fromArray($array['department']);
            else
                $department = $this->getDepartmentFacade()->load((int) $array['department']);

            $departmentInfoSysUsage->setDepartment($department);
        }

        if (isset($array['informationalSystem'])) {
            $informationalSystem = null;

            if (is_array($array['informationalSystem']))
                $informationalSystem = $this->getInformationalSystemFacade()->fromArray($array['informationalSystem']);
            else
                $informationalSystem = $this->getInformationalSystemFacade()->load((int) $array['informationalSystem']);

            $departmentInfoSysUsage->setInformationalSystem($informationalSystem);
        }

        return $departmentInfoSysUsage;
    }

    /**
     * @param array $source
     * @param \Orakulas\ModelBundle\Entity\DepartmentInfoSysUsage $destination
     */
    public function merge($destination, $source) {
        if (isset($source['department'])) {
            $department = null;

            if (is_array($source['department']))
                $department = $this->getDepartmentFacade()->fromArray($source['department']);
            else
                $department = $this->getDepartmentFacade()->load((int) $source['department']);

            $destination->setDepartment($department);
        }

        if (isset($source['informationalSystem'])) {
            $informationalSystem = null;

            if (is_array($source['informationalSystem']))
                $informationalSystem = $this->getInformationalSystemFacade()->fromArray($source['informationalSystem']);
            else
                $informationalSystem = $this->getInformationalSystemFacade()->load((int) $source['informationalSystem']);

            $destination->setInformationalSystem($informationalSystem);
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
     * @param \Orakulas\ModelBundle\Facades\InformationalSystemFacade $informationalSystemFacade
     */
    public function setInformationalSystemFacade($informationalSystemFacade)
    {
        $this->informationalSystemFacade = $informationalSystemFacade;
    }

    /**
     * @return \Orakulas\ModelBundle\Facades\InformationalSystemFacade
     */
    public function getInformationalSystemFacade()
    {
        return $this->informationalSystemFacade;
    }
}
