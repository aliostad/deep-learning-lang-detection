<?php
    namespace Mailing;

    use Zend\ServiceManager\ServiceLocatorAwareInterface;

    /**
     * Class MailServiceProviderTrait
     * @package Mailing
     */
    trait MailingServiceProviderTrait
    {
        /**
         * @var Service
         */
        protected $mailingService;

        /**
         * @return Service
         */
        public function getMailingService()
        {
            if (!$this->mailingService && $this instanceof ServiceLocatorAwareInterface) {
                $this->mailingService = $this->getServiceLocator()->get('Mailing\Service');
            }
            return $this->mailingService;
        }

        /**
         * @param Service $service
         * @return $this
         */
        public function setMailingService(Service $service)
        {
            $this->mailingService = $service;
            return $this;
        }
    }
