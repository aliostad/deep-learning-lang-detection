<?php
class ImageSize {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiHeight = '';
	var $__apiWidth = '';
	var $__apiDPI = '';
	var $__apiPrintHeight = '';
	var $__apiPrintWidth = '';
	var $__apiScaleSymbols = '';
	 
	 //***************************************************************
	// Constructor
	//***************************************************************
	function ImageSize() {
		$numargs = func_num_args();
		$this->__apiWidth = $numargs > 0 ? func_get_arg(0) : $__apiWidth;
		$this->__apiHeight = $numargs > 1 ? func_get_arg(1) : $__apiHeight;
	}
	
	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetHeight($__apiParam) { $this->__apiHeight = $__apiParam; }
	function SetWidth($__apiParam) { $this->__apiWidth = $__apiParam; }
	function SetDPI($__apiParam) { $this->__apiDPI = $__apiParam; }
	function SetPrintHeight($__apiParam) { $this->__apiPrintHeight = $__apiParam; }
	function SetPrintWidth($__apiParam) { $this->__apiPrintWidth = $__apiParam; }
	function SetScaleSymbols($__apiParam) { $this->__apiScaleSymbols = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['height'] = CheckProperty($this->__apiHeight);
		$__apiProperties['width'] = CheckProperty($this->__apiWidth);
		$__apiProperties['dpi'] = CheckProperty($this->__apiDPI);
		$__apiProperties['printheight'] = CheckProperty($this->__apiPrintHeight);
		$__apiProperties['printwidth'] = CheckProperty($this->__apiPrintWidth);
		$__apiProperties['scalesymbols'] = CheckProperty($this->__apiScaleSymbols);
		
		$__apiXML = '<IMAGESIZE ';
		
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