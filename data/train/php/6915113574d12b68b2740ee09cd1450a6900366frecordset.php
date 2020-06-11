<?php
class Recordset {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiFields = '';  
	var $__apiFieldCount = '';  
	var $__apiCurrentRecord = '';  
	var $__apiRecords = '';  
	var $__apiRecordCount = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Recordset() {
		$this->__apiFields = array();
		$this->__apiFieldCount = 0;
		$this->__apiCurrentRecord = -1;
		$this->__apiRecords = array();
		$this->__apiRecordCount = 0;
	}
	
	//***************************************************************
	// Public Methods
	//***************************************************************
	function AddField($__apiParam) { 
		if(!in_array($__apiParam, $this->__apiFields)) {
			$this->__apiFields[] = $__apiParam;
			$this->__apiFieldCount++;
		}
	}
	function AddRecord($__apiParam){
      $this->__apiRecords[$this->__apiRecordCount++] = $__apiParam;
   }
	function MoveNext() {
		$this->__apiCurrentRecord++;
		if ($this->__apiCurrentRecord < $this->__apiRecordCount) {
			return $this->__apiRecords[$this->__apiCurrentRecord];
		}
	}
	function MovePrevious() {
		$this->__apiCurrentRecord--;
		if ($this->__apiCurrentRecord > -1) {
			return $this->__apiRecords[$this->__apiCurrentRecord];
		}
	}
	function MoveCurrent() {
		return $this->__apiRecords[$this->__apiCurrentRecord];
	}
	function MoveTo($__apiParam) {
		if ($this->__apiRecordCount > 0) {
			if (($__apiParam > -1) && ($__apiParam < $this->__apiRecordCount)) {
				$this->__apiCurrentRecord = $__apiParam;
			}
		}
	}
	function MoveLast() {
		if ($this->__apiRecordCount > 0) {
			$this->__apiCurrentRecord = $this->__apiRecordCount - 1;
		}
	}
	function MoveFirst() {
		if ($this->__apiRecordCount > 0) {
			$this->__apiCurrentRecord = 0;
		}
	}  
}
?>
