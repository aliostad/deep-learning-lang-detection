<?php

class CreateServiceOrder extends PM_Bizaction
{
    public function execute()
    {
         $service_order = &$_SESSION['service_order'];
         
         $service_order['owner_id'] = PM_Context::getCurrentOwnerID();
         //$service_order['manager_id'] = 1;
  
         PM_Debug::throwVar('service_order', $service_order);
         
         $serviceOrderObj = PMServiceOrder::createInstance($service_order);
         $serviceOrderObj->saveServiceOrder();
         $service_order = $serviceOrderObj->getServiceOrderByID();
    }
}

?>
