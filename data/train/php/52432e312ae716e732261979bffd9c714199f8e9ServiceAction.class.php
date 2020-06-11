<?php

class ServiceAction extends CommonAction {

    public function index() {
        $service = M('service');
        $donate = $service->getByName('捐赠流程介绍');
        $this->assign('dwords',$list);
        $this->getServiceList();

        $this->display();
    }

    public function serviceDts() {
        $id = $_GET['id'];
        $service = M('service');
        $list = $service->find($id);
        $this->assign('serviceDts', $list);

        $this->getServiceList();
        $this->display();
    }

    public function getServiceList(){
        $service = M('service');
        $list = $service->select();
         $this->assign('service', $list);
    }

}

?>
