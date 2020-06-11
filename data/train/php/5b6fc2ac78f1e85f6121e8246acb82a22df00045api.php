<?php

	class api_api {
		
		public static function serialize($request,$format='json') {
			$api=new api_apidata($request);
			//$api=new api_classApi($request);
			if(isset($_GET['format'])) {
				switch ($_GET['format']) {
					case 'xml':
						$api->printXML();
						break;
					case 'div':
					case 'table':
					case 'list':
					case 'select':
						$api->printHTML($_GET['format']);
						break;
					default:
						$api->printJSON();
				}
			} else {
				$api->printJSON();
			}
		}
		
		public function request($request) {
			$api=new api_apidata(explode("/",$request));
			return $api->getList();
		}
		
	}

?>