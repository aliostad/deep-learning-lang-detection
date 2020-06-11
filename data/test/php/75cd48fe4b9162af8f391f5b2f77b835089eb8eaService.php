<?php
/**** @package    Basic MVC framework* @author     Jeremie Litzler* @copyright  Copyright (c) 2014* @license* @link* @since* @filesource*/// ------------------------------------------------------------------------
/**** Service Dao Class** @package     Application/PMTool* @subpackage  Models/Dao* @category    Service* @author      FWM DEV Team* @link*/
namespace Applications\PMTool\Models\Dao;if ( ! defined('__EXECUTION_ACCESS_RESTRICTION__')) exit('No direct script access allowed');
class Service extends \Library\Entity{  public     $service_id,    $pm_id,    $service_type,    $service_name,    $service_url,    $service_address,    $service_contact_name,    $service_contact_phone,    $service_contact_email,    $service_active;
  const     SERVICE_ID_ERR = 0,    PM_ID_ERR = 1,    SERVICE_TYPE_ERR = 2,    SERVICE_NAME_ERR = 3,    SERVICE_URL_ERR = 4,    SERVICE_ADDRESS_ERR = 5,    SERVICE_CONTACT_NAME_ERR = 6,    SERVICE_CONTACT_PHONE_ERR = 7,    SERVICE_CONTACT_EMAIL_ERR = 8,    SERVICE_ACTIVE_ERR = 9;
  // SETTERS //  public function setService_id($service_id) {      $this->service_id = $service_id;  }
  public function setPm_id($pm_id) {      $this->pm_id = $pm_id;  }
  public function setService_type($service_type) {      $this->service_type = $service_type;  }
  public function setService_name($service_name) {      $this->service_name = $service_name;  }
  public function setService_url($service_url) {      $this->service_url = $service_url;  }
  public function setService_address($service_address) {      $this->service_address = $service_address;  }
  public function setService_contact_name($service_contact_name) {      $this->service_contact_name = $service_contact_name;  }
  public function setService_contact_phone($service_contact_phone) {      $this->service_contact_phone = $service_contact_phone;  }
  public function setService_contact_email($service_contact_email) {      $this->service_contact_email = $service_contact_email;  }
  public function setService_active($service_active) {      $this->service_active = $service_active;  }
  // GETTERS //  public function service_id() {    return $this->service_id;  }
  public function pm_id() {    return $this->pm_id;  }
  public function service_type() {    return $this->service_type;  }
  public function service_name() {    return $this->service_name;  }
  public function service_url() {    return $this->service_url;  }
  public function service_address() {    return $this->service_address;  }
  public function service_contact_name() {    return $this->service_contact_name;  }
  public function service_contact_phone() {    return $this->service_contact_phone;  }
  public function service_contact_email() {    return $this->service_contact_email;  }
  public function service_active() {    return $this->service_active;  }
}