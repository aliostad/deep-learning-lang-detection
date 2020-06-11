<?php
namespace GoetasWebservices\XML\WSDLReader\Events;

use GoetasWebservices\XML\WSDLReader\Wsdl\Service;
use Symfony\Component\EventDispatcher\Event;

class ServiceEvent extends WsdlEvent
{
    /**
     * @var \GoetasWebservices\XML\WSDLReader\Wsdl\Service
     */
    protected $Service;

    public function __construct(Service $Service, \DOMElement $node)
    {
        parent::__construct($node);
        $this->Service = $Service;
    }

    /**
     * @return \GoetasWebservices\XML\WSDLReader\Wsdl\Service
     */
    public function getService()
    {
        return $this->Service;
    }
}