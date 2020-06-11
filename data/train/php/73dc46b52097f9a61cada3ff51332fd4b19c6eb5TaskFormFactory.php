<?php

namespace App\Forms;

use App\Model\Facade;

/**
 * TaskFormFactory
 *
 * @author Petr Poupě
 */
class TaskFormFactory extends FormFactory
{

    private $entityId;

    /** @var Facade\ProjectFacade */
    private $projectFacade;

    /** @var array */
    private $projects;

    /** @var Facade\UserFacade */
    private $userFacade;

    /** @var array */
    private $users;

    /** @var Facade\StatusFacade */
    private $statusFacade;

    /** @var array */
    private $states;

    public function __construct(IFormFactory $formFactory
    , Facade\ProjectFacade $projectFacade
    , Facade\UserFacade $userFacade
    , Facade\StatusFacade $statusFacade)
    {
        parent::__construct($formFactory);
        $this->projectFacade = $projectFacade;
        $this->userFacade = $userFacade;
        $this->statusFacade = $statusFacade;
    }

    /**
     * 
     * @param type $id
     * @return TaskFormFactory
     */
    public function setEntityId($id)
    {
        $this->entityId = $id;
        return $this;
    }

    private function getProjects()
    {
        if ($this->projects === NULL) {
            $this->projects = $this->projectFacade->findPairs("name");
        }
        return $this->projects;
    }

    private function getUsers()
    {
        if ($this->users === NULL) {
            $this->users = $this->userFacade->findPairs("username");
        }
        return $this->users;
    }

    private function getStates()
    {
        if ($this->states === NULL) {
            $this->states = $this->statusFacade->findPairs("name");
        }
        return $this->states;
    }

    public function create()
    {
        $form = $this->formFactory->create();
        $namePlaceholder = $this->isAdding() ? "New Task" : "Task #{$this->entityId}";
        $form->addText('name', 'Name')
                ->setAttribute("placeholder", $namePlaceholder);
        $form->addSelect2('project', 'Project', $this->getProjects())
                ->setRequired("Select some project");
        $form->addWysiHtml("text", "Text", "7")
                ->setRequired("Please describe your problem to solve")
                ->setAttribute("placeholder", "Describe your problem");
        $form->addSpinner("priority", "Priority")
                ->setMin("1")
                ->setMax("10")
                ->setInverse()
                ->setLeftButton("blue")
                ->setRightButton("red")
                ->setOption("description", "max. priority is 1");
        $today = new \Nette\Utils\DateTime;
        $form->addDatePicker("dueDate", "Due date")
                ->setStartDate($today)
                ->setTodayHighlight()
                ->setDefaultValue($today)
                ->setPlaceholder($today->format("d.m.Y"));
        $form->addSelect2("solver", "Solver", $this->getUsers())
                ->setPrompt("without solver");
        $form->addSelect2("status", "Status", $this->getStates());

        $form->addSubmit('_submit', 'Save');
        $form->addSubmit('submitContinue', 'Save and continue edit');
        return $form;
    }

}
