<?php
namespace ValuSo\Feature;

use ValuSo\Broker\ServiceBroker;

trait ServiceBrokerTrait
{
    /**
     * Service broker instance
     *
     * @var \ValuSo\Broker\ServiceBroker
     */
    protected $serviceBroker;
    
    /**
     * Retrieve service broker instance
     *
     * @return \ValuSo\Broker\ServiceBroker
     */
    public function getServiceBroker()
    {
        return $this->serviceBroker;
    }
    
    /**
     * @see \ValuSo\Feature\ServiceBrokerAwareInterface::setServiceBroker()
     */
    public function setServiceBroker(ServiceBroker $serviceBroker)
    {
        $this->serviceBroker = $serviceBroker;
    }
}