<?php
class Get_Image {	
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiAutoResize = '';
	var $__apiShow = '';
	var $__apiPropertyObject = '';
	var $__apiEnvironmentObject = '';
	var $__apiWorkspacesObject = '';
	var $__apiCount = 0;
	var $__apiLayerArray = array();
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Get_Image() {
		$numargs = func_num_args();
		$this->__apiPropertyObject = $numargs > 0 ? func_get_arg(0) : $__apiPropertyObject;
	}
	
	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetAutoResize($__apiParam) { $this->__apiAutoResize = $__apiParam; }
	function SetShow($__apiParam) { $this->__apiShow = $__apiParam; }
	function SetPropertyObject($__apiParam) { $this->__apiPropertyObject = $__apiParam; }
	function SetEnvironmentObject($__apiParam) { $this->__apiEnvironmentObject = $__apiParam; }
	function SetWorkspacesObject($__apiParam) { $this->__apiWorkspacesObject = $__apiParam; }
	function Add($__apiParam) {
		$this->__apiLayerArray[count($this->__apiLayerArray)] = $__apiParam;
		$this->__apiCount++;
	}
	function Clear() {
		unset($this->__apiLayerArray);
	}
	function Remove($__apiParam) {
		/// 
	}
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['autoresize'] = CheckProperty($this->__apiAutoResize);
		$__apiProperties['show'] = CheckProperty($this->__apiShow);
		
		$__apiXML = '<GET_IMAGE ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		$__apiXML .= '>';
		
		if (is_object($this->__apiPropertyObject)) {
			$__apiXML .= $this->__apiPropertyObject->WriteXML();
		} else {
			return 'Error: Get_Image() object contains no properties';	
		}
		if (is_object($this->__apiEnvironmentObject)) {
			$__apiXML .= $this->__apiEnvironmentObject->WriteXML();
		}
		if (is_object($this->__apiWorkspacesObject)) {
			$__apiXML .= $this->__apiWorkspacesObject->WriteXML();
		}
		if (count($this->__apiLayerArray) > 0) {
			for ($i=0;$i < count($this->__apiLayerArray);$i++) {
				if ($this->__apiLayerArray[$i]) {
					$__apiXML .= $this->__apiLayerArray[$i]->WriteXML();
				}
			}
		}
		
		$__apiXML .= '</GET_IMAGE>';
		
		return $__apiXML;
	}
}	
?>