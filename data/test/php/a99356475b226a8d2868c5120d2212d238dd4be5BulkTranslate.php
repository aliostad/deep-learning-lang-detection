<?php
namespace Lang\Service;

class BulkTranslate 
{
    protected $textdomainService;
    protected $translationStorageService;

    public function getTranslatorTextdomain()
    {
        return $this->getTextdomainService()->getTextdomain();
    }

    public function getTextdomainService()
    {
        return $this->textdomainService;
    }

    public function setTextdomainService($service)
    {
        $this->textdomainService = $service;
        return $this;
    }

    public function getTranslationStorageService()
    {
        return $this->translationStorageService;
    }

    public function setTranslationStorageService($service)
    {
        $this->translationStorageService = $service;
        return $this;
    }
}
