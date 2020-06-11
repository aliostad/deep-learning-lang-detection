<?php
/**
 * @file
 * Definition of IPVenger\Service\IPVengerServiceFactory.
 */

namespace IPVenger\Service;

use IPVenger\Service\IPVengerServiceFake;
use IPVenger\Service\IPVengerServiceImpl;

class IPVengerServiceFactory {

  /**
   * Instantiates an IPVenger service class for IPVenger.
   *
   * @return IPVenger\Service\IPVengerService
   *   The IPVengerService object.
   */
  public static function get() {
    global $conf;

    // Return a real or fake object (for testing)?
    return isset($conf['IPVengerServiceFake']) ? new IPVengerServiceFake() : new IPVengerServiceImpl();
  }
}
