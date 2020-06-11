<?php

namespace AppBundle\Tests\Updater;

use AppBundle\Entity\Core\Incident;
use AppBundle\Entity\Core\Service;
use AppBundle\Updater\ServiceStatusUpdater;

class ServiceStatusUpdaterTest extends \PHPUnit_Framework_TestCase
{
    public function testOutageService()
    {
        $serviceMock = $this->getService();
        $serviceMock->setStatus(Service::OUTAGE);

        $incidentMock = $this->getIncident();

        $serviceStatusUpdater = new ServiceStatusUpdater();
        $service = $serviceStatusUpdater->update((new Service()), $incidentMock);

        $this->assertSame($service->getStatus(), $serviceMock->getStatus());
    }

    public function testOperationnalService()
    {
        $serviceMock = $this->getService();
        $serviceMock->setStatus(Service::OPERATIONNAL);

        $incidentMock = $this->getIncident(false);

        $serviceStatusUpdater = new ServiceStatusUpdater();
        $service = $serviceStatusUpdater->update((new Service()), $incidentMock);
        $this->assertSame($service->getStatus(), $serviceMock->getStatus());
    }

    private function getService()
    {
        return (new Service())->setName('My Test Service');
    }

    private function getIncident($outage = true)
    {
        $status = $outage ? Incident::IDENTIFIED : Incident::RESOLVED;

        return (new Incident())->setStatus($status);
    }
}
