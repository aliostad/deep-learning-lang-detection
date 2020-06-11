<?php

namespace App\MainBundle\Service;

use App\MainBundle\Entity\UserRepository;
use Doctrine\ORM\EntityManager;

trait DoctrineTrait
{
    use ContainerAwareTrait;

    /**
     * @return Registry
     */
    public function getDoctrine()
    {
        return $this->getContainer()->get('doctrine');
    }

    /**
     * @param null $name
     * @return EntityManager
     */
    public function getEntityManager($name = null)
    {
        return $this->getDoctrine()->getManager($name);
    }

    /**
     * @param $name
     * @return \Doctrine\Common\Persistence\ObjectRepository
     */
    public function getRepository($name)
    {
        return $this->getDoctrine()->getRepository('MainBundle:' . $name);
    }


    /**
     * @return UserRepository
     */
    public function getUserRepository()
    {
        return $this->getRepository('User');
    }

    /**
     * @return EnterpriseRepository
     */
    public function getEnterpriseRepository()
    {
        return $this->getRepository('Enterprise');
    }

    /**
     * @return SubdivisionRepository
     */
    public function getSubdivisionRepository()
    {
        return $this->getRepository('Subdivision');
    }

    /**
     * @return ProfessionRepository
     */
    public function getProfessionRepository()
    {
        return $this->getRepository('Profession');
    }

    /**
     * @return ProfessionkindRepository
     */
    public function getProfessionkindRepository()
    {
        return $this->getRepository('Professionkind');
    }

    /**
     * @return MedicalkindRepository
     */
    public function getMedicalkindRepository()
    {
        return $this->getRepository('Medicalkind');
    }

    /**
     * @return MedicaltypeRepository
     */
    public function getMedicaltypeRepository()
    {
        return $this->getRepository('Medicaltype');
    }

    /**
     * @return TraumakindRepository
     */
    public function getTraumakindRepository()
    {
        return $this->getRepository('Traumakind');
    }

    /**
     * @return TraumacauseRepository
     */
    public function getTraumacauseRepository()
    {
        return $this->getRepository('Traumacause');
    }

    /**
     * @return EquipmentgroupRepository
     */
    public function getEquipmentgroupRepository()
    {
        return $this->getRepository('Equipmentgroup');
    }

    /**
     * @return EquipmentsubgroupRepository
     */
    public function getEquipmentsubgroupRepository()
    {
        return $this->getRepository('Equipmentsubgroup');
    }

    /**
     * @return ExpensekindRepository
     */
    public function getExpensekindRepository()
    {
        return $this->getRepository('Expensekind');
    }

    /**
     * @return CategoryReportRepository
     */
    public function getCategoryReportRepository()
    {
        return $this->getRepository('CategoryReport');
    }

    /**
     * @return ReportRepository
     */
    public function getReportRepository()
    {
        return $this->getRepository('Report');
    }

    /**
     * @return TechnicalexaminationkindRepository
     */
    public function getTechnicalexaminationkindRepository()
    {
        return $this->getRepository('Technicalexaminationkind');
    }

    /**
     * @return TechnicalexaminationtypeRepository
     */
    public function getTechnicalexaminationtypeRepository()
    {
        return $this->getRepository('Technicalexaminationtype');
    }

    /**
     * @return TechnicalexaminationcauseRepository
     */
    public function getTechnicalexaminationcauseRepository()
    {
        return $this->getRepository('Technicalexaminationcause');
    }

    /**
     * @return EmployeeRepository
     */
    public function getEmployeeRepository()
    {
        return $this->getRepository('Employee');
    }

    /**
     * @return MedicalRepository
     */
    public function getMedicalRepository()
    {
        return $this->getRepository('Medical');
    }

    /**
     * @return TraumaRepository
     */
    public function getTraumaRepository()
    {
        return $this->getRepository('Trauma');
    }

    /**
     * @return EquipmentRepository
     */
    public function getEquipmentRepository()
    {
        return $this->getRepository('Equipment');
    }

    /**
     * @return TechnicalexaminationRepository
     */
    public function getTechnicalexaminationRepository()
    {
        return $this->getRepository('Technicalexamination');
    }

    /**
     * @return ExpenseRepository
     */
    public function getExpenseRepository()
    {
        return $this->getRepository('Expense');
    }
}