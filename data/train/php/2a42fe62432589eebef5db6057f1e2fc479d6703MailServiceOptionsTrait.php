<?php

namespace EnliteMail\Service;

use EnliteMail\Service\MailService;
use EnliteMail\Exception\RuntimeException;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

trait MailServiceOptionsTrait
{

    /**
     * @var MailServiceOptions
     */
    protected $mailServiceOptions = null;

    /**
     * @param MailServiceOptions $mailService
     */
    public function setMailServiceOptions(MailServiceOptions $mailService)
    {
        $this->mailServiceOptions = $mailService;
    }

    /**
     * @return MailServiceOptions
     * @throws RuntimeException
     */
    public function getMailServiceOptions()
    {
        if (null === $this->mailServiceOptions) {
            if ($this instanceof ServiceLocatorAwareInterface || method_exists($this, 'getServiceLocator')) {
                $this->mailServiceOptions = $this->getServiceLocator()->get('EnliteMailServiceOptions');
            } else {
                if (property_exists($this, 'serviceLocator')
                    && $this->serviceLocator instanceof ServiceLocatorInterface
                ) {
                    $this->mailServiceOptions = $this->serviceLocator->get('EnliteMailServiceOptions');
                } else {
                    throw new RuntimeException('Service locator not found');
                }
            }
        }
        return $this->mailServiceOptions;
    }


}
