<?php
/**`
 * Created by PhpStorm.
 * User: Jesse Griffin
 * Date: 1/7/15
 * Time: 3:04 PM
 *
 * This form handler receives the entire form $_POST request as an array
 */

namespace Stc\MusiczarconiaBundle\Form\Handler;

use Stc\MusiczarconiaBundle\Entity\Clients;
use Stc\MusiczarconiaBundle\Repository\ClientRepository;
use Stc\MusiczarconiaBundle\Repository\SchedulerRepository;
use Stc\MusiczarconiaBundle\Entity\Scheduler;

class AppointmentFormHandler
{
    protected $clientRepository;

    protected $schedulerRepository;

    public function __construct(ClientRepository $clientRepository,SchedulerRepository $schedulerRepository)
    {
        $this->schedulerRepository = $schedulerRepository;
        $this->clientRepository = $clientRepository;
    }

    public function handle($requestParams)
    {
        $this->clientRepository->saveClient($requestParams);


    }

}