<?php
class TextSymbol {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiAntiAliasing = '';
	var $__apiBlockout = '';
	var $__apiFont = '';
	var $__apiFontColor = '';
	var $__apiFontSize = '';
	var $__apiFontStyle = '';
	var $__apiGlowing = '';
	var $__apiInterval = '';
	var $__apiOutline = '';
	var $__apiPrintMode = '';
	var $__apiShadow = '';
	var $__apiTransparency = '';

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetAntiAliasing($__apiParam) { $this->__apiAntiAliasing = $__apiParam; }
	function SetBlockout($__apiParam) { $this->__apiBlockout = $__apiParam; }
	function SetFont($__apiParam) { $this->__apiFont = $__apiParam; }
	function SetFontColor($__apiParam) { $this->__apiFontColor = $__apiParam; }
	function SetFontSize($__apiParam) { $this->__apiFontSize = $__apiParam; }
	function SetFontStyle($__apiParam) { $this->__apiFontStyle = $__apiParam; }
	function SetGlowing($__apiParam) { $this->__apiGlowing = $__apiParam; }
	function SetInterval($__apiParam) { $this->__apiInterval = $__apiParam; }
	function SetOutline($__apiParam) { $this->__apiOutline = $__apiParam; }
	function SetPrintMode($__apiParam) { $this->__apiPrintMode = $__apiParam; }
	function SetShadow($__apiParam) { $this->__apiShadow = $__apiParam; }
	function SetTransparency($__apiParam) { $this->__apiTransparency = $__apiParam; }
	
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['antialiasing'] = CheckProperty($this->__apiAntiAliasing);
		$__apiProperties['blockout'] = CheckProperty($this->__apiBlockout);
		$__apiProperties['font'] = CheckProperty($this->__apiFont);
		$__apiProperties['fontcolor'] = CheckProperty($this->__apiFontColor);
		$__apiProperties['fontsize'] = CheckProperty($this->__apiFontSize);
		$__apiProperties['fontstyle'] = CheckProperty($this->__apiFontStyle);
		$__apiProperties['glowing'] = CheckProperty($this->__apiGlowing);
		$__apiProperties['interval'] = CheckProperty($this->__apiInterval);
		$__apiProperties['outline'] = CheckProperty($this->__apiOutline);
		$__apiProperties['printmode'] = CheckProperty($this->__apiPrintMode);
		$__apiProperties['shadow'] = CheckProperty($this->__apiShadow);
		$__apiProperties['transparency'] = CheckProperty($this->__apiTransparency);
			
		$__apiXML = '<TEXTSYMBOL ';
		
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
