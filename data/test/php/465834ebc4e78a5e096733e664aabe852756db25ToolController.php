<?php

namespace LemoCore\Controller;

use LemoCore\Facade\Tool as FacadeTool;
use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;

class ToolController extends AbstractActionController
{
    /**
     * @var FacadeTool
     */
    protected $facadeTool;

    /**
     * List of availaible tools
     *
     * @return ViewModel
     */
    public function indexAction()
    {
        return new ViewModel(array(
        ));
    }

    /**
     * Update DB structure
     *
     * @return mixed
     */
    public function updateDbAction()
    {
        $this->getFacadeTool()->updateDbStructure();

        // Flash message
        $this->plugin('notice')->success('DB structure has been successfully updated');

        // Redirect
        return $this->plugin('redirect')->toRoute('core/tool');
    }

    /**
     * @param FacadeTool $facadeTool
     * @return ToolController
     */
    public function setFacadeTool(FacadeTool $facadeTool)
    {
        $this->facadeTool = $facadeTool;

        return $this;
    }

    /**
     * @return FacadeTool
     */
    public function getFacadeTool()
    {
        return $this->facadeTool;
    }
}
