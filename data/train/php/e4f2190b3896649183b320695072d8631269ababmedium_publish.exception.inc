<?php
/**
 * @file
 * Handles exceptions for the Medium class.
 */

/**
 * Extends the regular Exception class.
 */
class MediumDrupalException extends Exception {

  protected $apiMessage;
  protected $apiCode;

  /**
   * Construct.
   */
  public function __construct($message, $code, $api_message = NULL, $api_code = NULL) {
    $this->apiMessage = $api_message;
    $this->apiCode = $api_code;
    parent::__construct($message, $code);
  }

  /**
   * Returns the API message.
   */
  public function getApiMessage() {
    return $this->apiMessage;
  }

  /**
   * Returns the API error code.
   */
  public function getApiCode() {
    return $this->apiCode;
  }

}
