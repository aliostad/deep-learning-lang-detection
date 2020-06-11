<?php
 $view_config = array(
	'req_params' =>
		array(
		    'print' => array('param_value' => true,
		                     'config' => array(
		                                  'show_header' => true,
		                                  'show_footer' => false,
		                                  'view_print'  => true,
		                                  'show_title' => false,
                                          'show_subpanels' => false,
                                          'show_javascript' => true,
                                          'show_search' => false,)
                       ),
			'to_pdf' => array('param_value' => true,
							   'config' => array(
		 										'show_all' => false
		 										),
		 				),
		 	'to_csv' => array('param_value' => true,
							   'config' => array(
		 										'show_all' => false
		 										),
		 				),
		),
 );
?>
