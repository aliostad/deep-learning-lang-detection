<?php

namespace SpeckCatalog\Service;

class Company extends AbstractService
{
    protected $contactService;

    protected $entityMapper = 'speckcatalog_company_mapper';

    public function findById($companyId)
    {
        return $this->find(array('company_id' => $companyId));
    }

    /**
     * @return contactService
     */
    public function getContactService()
    {
        if (null === $this->contactService) {
            $this->contactService = $this->getServiceLocator()->get('SpeckContact\Service\ContactService');
        }
        return $this->contactService;
    }

    /**
     * @param $contactService
     * @return self
     */
    public function setContactService($contactService)
    {
        $this->contactService = $contactService;
        return $this;
    }
}
