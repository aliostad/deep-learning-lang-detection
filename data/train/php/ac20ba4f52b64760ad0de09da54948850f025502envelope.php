<?php
class Envelope {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiMaxX = '';  // xRTop
	var $__apiMaxY = '';  // yRTop
	var $__apiMinX = '';  // xLBottom
	var $__apiMinY = '';  // yLBottom
	var $__apiName = '';
	var $__apiReaspect = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Envelope() {
		$numargs = func_num_args();
		$this->__apiMaxX = $numargs > 0 ? func_get_arg(0) : $__apiMaxX;
		$this->__apiMaxY = $numargs > 1 ? func_get_arg(1) : $__apiMaxY;
		$this->__apiMinX = $numargs > 2 ? func_get_arg(2) : $__apiMinX;
		$this->__apiMinY = $numargs > 3 ? func_get_arg(3) : $__apiMinY;
	}

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetMaxX($__apiParam) { $this->__apiMaxX = $__apiParam; }
	function SetMaxY($__apiParam) { $this->__apiMaxY = $__apiParam; }
	function SetMinX($__apiParam) { $this->__apiMinX = $__apiParam; }
	function SetMinY($__apiParam) { $this->__apiMinY = $__apiParam; }
	function SetName($__apiParam) { $this->__apiName = $__apiParam; }
	function SetReaspect($__apiParam) { $this->__apiReaspect = $__apiParam; }
	
	function Area() {
		return ($this->__apiMaxX - $this->__apiMinX) * ($this->__apiMaxY - $this->__apiMinY);
	}
	function Height() {
		return abs($this->__apiMaxY - $this->__apiMinY);
	}
	function Width() {
		return abs($this->__apiMaxX - $this->__apiMinX);
	}
	function Expand($__apiDXParam, $__apiDYParam, $__apiRatioParam) {
		if ($__apiRatioParam) {
			// scaled expansion
			$__apiDXParam = ($__apiDXParam - 1) * ($this->__apiMaxY - $this->__apiMinY) / 2.0;
			$__apiDYParam = ($__apiDYParam - 1) * ($this->__apiMaxX - $this->__apiMinX) / 2.0;
		}
		$this->__apiMinX -= $__apiDXParam;
		$this->__apiMinY -= $__apiDYParam;
		$this->__apiMaxX += $__apiDXParam;
		$this->__apiMaxY += $__apiDYParam;
	}
	function Expand2(&$__apiMapParam, $__apiFactorParam=2) {
		$__apiFactorParam = 1 / $__apiFactorParam;
		
		$__apiWidth = $__apiMapParam->GetMapWidth();
		$__apiHeight = $__apiMapParam->GetMapHeight();

		$__apiCenterX = $this->__apiMinX + ($__apiWidth / 2);
		$__apiCenterY = $this->__apiMinY + ($__apiHeight / 2);
		
		$__apiWidth = $__apiWidth / ($__apiFactorParam * 2);
		$__apiHeight = $__apiHeight / ($__apiFactorParam * 2);
		
		$this->__apiMinX = $__apiCenterX - $__apiWidth;
		$this->__apiMaxX = $__apiCenterX + $__apiWidth;
		$this->__apiMinY = $__apiCenterY - $__apiHeight;
		$this->__apiMaxY = $__apiCenterY + $__apiHeight;
	}
	function CenterAt($__apiPointXParam,$__apiPointYParam) {
		$__apiDX = $__apiPointXParam - (($this->__apiMinX + $this->__apiMaxX) / 2.0);
		$__apiDY = $__apiPointYParam - (($this->__apiMinY + $this->__apiMaxY) / 2.0);
		$this->offset($__apiDX,$__apiDY);
	}
	function Offset($__apiDXParam,$__apiDYParam) {
		$this->__apiMinX += $__apiDXParam;
		$this->__apiMinY += $__apiDYParam;
		$this->__apiMaxX += $__apiDXParam;
		$this->__apiMaxY += $__apiDYParam;
	}
	function Union($__apiEnvelopeParam) {
		if($__apiEnvelopeParam->__apiMinX < $this->__apiMinX ) $this->__apiMinX = $__apiEnvelopeParam->__apiMinX;
		if($__apiEnvelopeParam->__apiMinY < $this->__apiMinY ) $this->__apiMinY = $__apiEnvelopeParam->__apiMinY;
		if($__apiEnvelopeParam->__apiMaxX > $this->__apiMaxX ) $this->__apiMaxX = $__apiEnvelopeParam->__apiMaxX;
		if($__apiEnvelopeParam->__apiMaxY > $this->__apiMaxY ) $this->__apiMaxY = $__apiEnvelopeParam->__apiMaxY;
	}
	function WriteXML() {
		$__apiProperties = array();
		$__apiProperties['maxx'] = CheckProperty($this->__apiMaxX);
		$__apiProperties['maxy'] = CheckProperty($this->__apiMaxY);
		$__apiProperties['minx'] = CheckProperty($this->__apiMinX);
		$__apiProperties['miny'] = CheckProperty($this->__apiMinY);
		$__apiProperties['name'] = CheckProperty($this->__apiName);
		$__apiProperties['reaspect'] = CheckProperty($this->__apiReaspect);
		
		$__apiXML = '<ENVELOPE ';

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