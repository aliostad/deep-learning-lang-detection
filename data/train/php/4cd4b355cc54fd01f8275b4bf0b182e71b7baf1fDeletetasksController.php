<?php
namespace Tasks\V1\Rpc\Deletetasks;

use Zend\Mvc\Controller\AbstractActionController;
use Model\Facade\TaskFacade;
use ZF\ContentNegotiation\ViewModel;

class DeletetasksController extends AbstractActionController
{

    /**
     *
     * @var TaskFacade
     */
    private $taskFacade;

    public function __construct($taskFacade)
    {
        $this->taskFacade = $taskFacade;
    }

    public function deletetasksAction()
    {
        $tasks = $this->taskFacade->getAll();
        
        foreach ($tasks as $task)
        {
            $this->taskFacade->deleteTask($task->getID());
        }
        
        return new ViewModel(array(
            "ack" => time(),
        ));
    }
}
