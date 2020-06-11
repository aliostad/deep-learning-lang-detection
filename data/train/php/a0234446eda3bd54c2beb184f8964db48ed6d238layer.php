<?php
class Layer {
	//***************************************************************
	// Set property defaults
	//***************************************************************
	var $__apiId = '';  
	var $__apiName = '';  
	var $__apiType = '';  
	var $__apiFeatureCount = '';  
	var $__apiMaxScale = '';
	var $__apiMinScale = '';
	var $__apiVisible = '';
	var $__apiCount = 0;
	var $__apiObjectsArray = array();
	var $__apiParentElement = '';
	var $__apiSpatialQuery = '';
	var $__apiQuery = '';
	var $__apiDataset = '';
	var $__apiRenderer = '';
	
	//***************************************************************
	// Constructor
	//***************************************************************
	function Layer() {
		$numargs = func_num_args();
		$this->__apiId = $numargs > 0 ? func_get_arg(0) : $__apiId;
		$this->__apiName = $numargs > 1 ? func_get_arg(1) : $__apiName;
		$this->__apiType = $numargs > 2 ? func_get_arg(2) : $__apiType;
	}

	//***************************************************************
	// Public Methods
	//***************************************************************
	function SetId($__apiParam) { $this->__apiId = $__apiParam; }
	function SetName($__apiParam) { $this->__apiName = $__apiParam; }
	function SetType($__apiParam) { $this->__apiType = $__apiParam; }
	function SetFeatureCount($__apiParam) { $this->__apiFeatureCount = $__apiParam; }
	function SetMaxScale($__apiParam) { $this->__apiMaxScale = $__apiParam; }
	function SetMinScale($__apiParam) { $this->__apiMinScale = $__apiParam; }
	function SetVisible($__apiParam) { $this->__apiVisible = $__apiParam; }
	function SetParentElement($__apiParam) { $this->__apiParentElement = $__apiParam; }
	function SetSpatialQuery($__apiParam) { $this->__apiSpatialQuery = $__apiParam; }
	function SetQuery($__apiParam) { $this->__apiQuery = $__apiParam; }
	function SetDataset($__apiParam) { $this->__apiDataset = $__apiParam; }
	function SetRenderer($__apiParam) { $this->__apiRenderer = $__apiParam; }
	
	function Add($__apiParam) {
		$this->__apiObjectsArray[count($this->__apiObjectsArray)] = $__apiParam;
		$this->__apiCount++;
	}
	function Clear() {
		unset($this->__apiObjectsArray);
	}
	function Remove($__apiParam) {
		/// 
	}
	
	function WriteXML() {
		$__apiProperties = array();
		if (strtoupper($this->__apiParentElement) == 'MAP' || strtoupper($this->__apiParentElement) == 'GET_IMAGE' || strtoupper($this->__apiParentElement) == 'GET_EXTRACT') {
			$__apiProperties['visible'] = CheckProperty($this->__apiVisible);
			$__apiProperties['name'] = CheckProperty($this->__apiName);
			$__apiProperties['type'] = CheckProperty($this->__apiType);
			$__apiProperties['featurecount'] = CheckProperty($this->__apiFeatureCount);
			$__apiProperties['maxscale'] = CheckProperty($this->__apiMaxScale);
			$__apiProperties['minscale'] = CheckProperty($this->__apiMinScale);
		}
		$__apiProperties['id'] = CheckProperty($this->__apiId);
		
		$__apiXML = '<LAYER ';
		
		reset($__apiProperties);
		while ($__apiArrayCell = each($__apiProperties)) {
			if (strlen($__apiArrayCell['value']) > 0) {
				$__apiXML .= $__apiArrayCell['key'] . '="' . $__apiArrayCell['value'] . '" ';
			}
		}
		$__apiXML .= '>';
		
		if (strtoupper($this->__apiType) == 'ACETATE') {
			if (count($this->__apiObjectsArray) > 0) {
				for ($i=0;$i < count($this->__apiObjectsArray);$i++) {
					if ($this->__apiObjectsArray[$i]) {
						$__apiXML .= $this->__apiObjectsArray[$i]->WriteXML();
					}
				}
			}
		}
		if ($this->__apiDataset) {
			$__apiXML .= $this->__apiDataset->WriteXML();
		}
		if ($this->__apiSpatialQuery) {
			$__apiXML .= $this->__apiSpatialQuery->WriteXML();
		}
		if ($this->__apiQuery) {
			$__apiXML .= $this->__apiQuery->WriteXML();
		}
		if ($this->__apiRenderer) {
			$__apiXML .= $this->__apiRenderer->WriteXML();
		}
		
		$__apiXML .= "</LAYER>";
		
		return $__apiXML;
	}
}	
?>