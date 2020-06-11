<?php
  require_once 'sqlitedao.php';
  
  function findByServiceId($serviceId) {
    $result = _findByServiceId($serviceId);
    error_log("Found Order ID: $result from Service ID: $serviceId");
    return $result;
  }
  
  function setPaid($serviceIds) {
    $idsStr = implode(", ", $serviceIds);
    error_log("Setting paid: $idsStr");
    _setPaid($serviceIds);
  }
    
  function saveService($serviceId, $orderId) {
    error_log("Saving Service ID: $serviceId / Order ID: $orderId");
    return _saveService($serviceId, $orderId);
  }
  
  function isPaid($serviceId) {
    return _isPaid($serviceId);
  }
  
  function createServiceId() {
    $result = _createServiceId();
    error_log("Creating Service ID: $result");
    return $result;
  }
?>
