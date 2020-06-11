<?php
if (!defined('_JEXEC'))
die('Direct Access to ' . basename(__FILE__) . ' is not allowed.');
/**
 * BatchFileSaveResponse.class.php
 */

/**
 * 
 *
 * @author    Avalara
 * @copyright � 2004 - 2011 Avalara, Inc.  All rights reserved.
 * @package   Batch
 */
class BatchFileSaveResponse {
  private $BatchFileSaveResult; // BatchFileSaveResult

  public function setBatchFileSaveResult($value){$this->BatchFileSaveResult=$value;} // BatchFileSaveResult
  public function getBatchFileSaveResult(){return $this->BatchFileSaveResult;} // BatchFileSaveResult

}

?>
