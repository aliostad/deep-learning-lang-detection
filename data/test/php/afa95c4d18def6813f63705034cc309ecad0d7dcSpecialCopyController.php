<?php

namespace Base\Controller;

use Zend\View\Model\ViewModel;

use Base\Form\SpecialCopyForm;
use Base\Model\SpecialCopy;

class SpecialCopyController extends BaseController
{
    private $SpecialCopyTable;

    public function listAction()
    {
        $list = $this->getSpecialCopyTable()->fetchAll();
        return new ViewModel(array(
            'list' => $list,
        ));
    }

    public  function addAction()
    {
        $form = new SpecialCopyForm();
    
        $request = $this->getRequest();
        if ($request->isPost()) {
            $specialCopy = new SpecialCopy();
            $form->setInputFilter($specialCopy->getInputFilter());
            $form->setData($request->getPost());

            if ($form->isValid()) {
                $specialCopy->exchangeArray($form->getData());
                $this->getSpecialCopyTable()->saveSpecialCopy($specialCopy);

                return $this->redirect()->toRoute('base', ['controller' => 'special-copy' , 'action' => 'list']);
            }
        }
        return new ViewModel(['form' => $form]);
    }

    public function editAction()
    {
        $id = (int) $this->params()->fromQuery('id', 0);
        if (!$id) {
            return $this->redirect()->toRoute('base', array('controller' => 'item','action' => 'add'));
        }

        $specialCopy = $this->getSpecialCopyTable()->getSpecialCopy($id);

        if ($specialCopy) {

            $specialCopy->begin_time = substr($specialCopy->begin_time, 0, 10);
            $specialCopy->end_time = substr($specialCopy->end_time, 0, 10);

            $form = new SpecialCopyForm();
            $form->bind($specialCopy);
            
            $request = $this->getRequest();
            if ($request->isPost()) {
                $form->setInputFilter($specialCopy->getInputFilter());
                $form->setData($request->getPost());

                if ($form->isValid()) {
                    $this->getSpecialCopyTable()->saveSpecialCopy($specialCopy);
            
                    return $this->redirect()->toRoute('base', ['controller' => 'special-copy' , 'action' => 'list']);
                }
            }
        }

        return new ViewModel(['id' => $id , 'form' => $form]);
    }

    public function deleteAction()
    {
        $request = $this->getRequest();
        if ($request->isPost()) {
            $id = $request->getPost('id');
            $this->getSpecialCopyTable()->deleteSpecialCopy($id);
        }

       return $this->redirect()->toRoute('base', ['controller' => 'special-copy' , 'action' => 'list']);
    }

    public function getSpecialCopyTable()
    {
        if (!$this->SpecialCopyTable) {
            $sm = $this->getServiceLocator();
            $this->SpecialCopyTable = $sm->get('Base\Model\SpecialCopyTable');
        }
        return $this->SpecialCopyTable;
    }
}
