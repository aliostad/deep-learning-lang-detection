<?php
class Get_Service_Info {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiDPI = '';
	var $__apiEnvelope = '';
	var $__apiExtensions = '';
	var $__apiFields = '';
	var $__apiRenderer = '';
	
	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetDPI($__apiParam) { $this->__apiDPI = $__apiParam; }
	function SetEnvelope($__apiParam) { $this->__apiEnvelope = $__apiParam; }
	function SetExtensions($__apiParam) { $this->__apiExtensions = $__apiParam; }
	function SetFields($__apiParam) { $this->__apiFields = $__apiParam; }
	function SetRenderer($__apiParam) { $this->__apiRenderer = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['dpi'] = CheckProperty($this->__apiDPI);
		$__apiProperties['envelope'] = CheckProperty($this->__apiEnvelope);
		$__apiProperties['extensions'] = CheckProperty($this->__apiExtensions);
		$__apiProperties['fields'] = CheckProperty($this->__apiFields);
		$__apiProperties['renderer'] = CheckProperty($this->__apiRenderer);
		
		$__apiXML = '<GET_SERVICE_INFO ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		
		$__apiXML .= '/>';
		return $__apiXML;
	}
}	
?>