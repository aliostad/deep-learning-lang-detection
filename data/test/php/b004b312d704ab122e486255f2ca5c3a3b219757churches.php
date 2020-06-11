<?php

	/*

	OUTPUT CHURCHES AS CSV

	How to use:
	Upload this file to your site root, and use this URL to download a CSV:
	http://www.site.com/export-churches.php

	*/

	require('../../_inc/config.php');

	$filename = getSiteId() . '_' . 'churches' . 'Export' . date('M') . '_' . date('d') . '_' . date('Y');

	// Header
	header("Content-type: text/csv");
	header("Content-Disposition: attachment; filename=" . $filename . ".csv");
	header("Pragma: no-cache");
	header("Expires: 0");

	// Functions
	function processItem($in){
		$out = trim($in);
		$out = str_replace('"','""',$out);
		$out = str_replace('&amp;','&',$out);
		$out = '"' . $out . '"';
		return $out;
	}

	// Headers
	$headers .= '"Name",'; 					// 0
	$headers .= '"Pastor",'; 				// 1
	$headers .= '"Denomination",'; 			// 2
	$headers .= '"Worship Style",'; 		// 3
	$headers .= '"Weekly Attendance",'; 	// 4
	$headers .= '"Worship Address",'; 		// 5
	$headers .= '"Street",'; 				// 6
	$headers .= '"Street 2",'; 				// 7
	$headers .= '"City",';					// 8
	$headers .= '"State",';					// 9
	$headers .= '"State Abbr",';			// 10
	$headers .= '"Zip",';					// 11
	$headers .= '"Country",';				// 12
	$headers .= '"Google Map",';			// 13
	$headers .= '"Postal Address",'; 		// 14
	$headers .= '"Website",';				// 15
	$headers .= '"Email",';					// 16
	$headers .= '"Phone",';					// 17
	$headers .= '"Image",';					// 18
	$headers .= '"Description",';			// 19
	$headers .= '"Service 1",';				// 20
	$headers .= '"Service 2",';				// 21
	$headers .= '"Service 3",';				// 22
	$headers .= '"Service 4",';				// 23
	$headers .= '"Service 5",';				// 24
	$headers .= '"Service 6",';				// 25
	$headers .= '"Group"';					// 26
	$headers .= "\n";

	// Lines
	$get_church_slugs = trim(getContent("church","display:list","show:__slug__~||~","noecho"),'~||~');

	$church_slugs_arr = explode('~||~',$get_church_slugs);

	natcasesort($church_slugs_arr);

	$church_slugs_arr = array_values($church_slugs_arr);

	$get_churches = '';

	for($i=0; $i<=(count($church_slugs_arr)-1); $i++){

		$get_churches .=
			getContent(
			"church",
			"display:detail",
			"find:" . $church_slugs_arr[$i],
			"show:__name__",
			"show:~||~",
			"show:__pastor__",
			"show:~||~",
			"show:__denomination__",
			"show:~||~",
			"show:__worship__",
			"show:~||~",
			"show:__attendance__",
			"show:~||~",
			"show:__address__",
			"show:~||~",
			"show:__street__",
			"show:~||~",
			"show:__street2__",
			"show:~||~",
			"show:__city__",
			"show:~||~",
			"show:__state__",
			"show:~||~",
			"show:__stateAB__",
			"show:~||~",
			"show:__zip__",
			"show:~||~",
			"show:__country__",
			"show:~||~",
			"show:__googlemap__",
			"show:~||~",
			"show:__postal__",
			"show:~||~",
			"show:__website__",
			"show:~||~",
			"show:__email__",
			"show:~||~",
			"show:__phone__",
			"show:~||~",
			"show:__imageurl__",
			"show:~||~",
			"show:__description__",
			"show:~||~",
			"show:__service1__",
			"show:~||~",
			"show:__service2__",
			"show:~||~",
			"show:__service3__",
			"show:~||~",
			"show:__service4__",
			"show:~||~",
			"show:__service5__",
			"show:~||~",
			"show:__service6__",
			"show:~|~|~",
			"emailencode:no",
			"noecho"
			);

		}

		$get_churches_array = explode("~|~|~", $get_churches);

		for($i=0;$i<count($get_churches_array)-1;$i++){

			$church_array = explode("~||~",$get_churches_array[$i]);

			$line =
			processItem($church_array[0]) . "," .
			processItem($church_array[1]) . "," .
			processItem($church_array[2]) . "," .
			processItem($church_array[3]) . "," .
			processItem($church_array[4]) . "," .
			processItem($church_array[5]) . "," .
			processItem($church_array[6]) . "," .
			processItem($church_array[7]) . "," .
			processItem($church_array[8]) . "," .
			processItem($church_array[9]) . "," .
			processItem($church_array[10]) . "," .
			processItem($church_array[11]) . "," .
			processItem($church_array[12]) . "," .
			processItem($church_array[13]) . "," .
			processItem($church_array[14]) . "," .
			processItem($church_array[15]) . "," .
			processItem($church_array[16]) . "," .
			processItem($church_array[17]) . "," .
			processItem($church_array[18]) . "," .
			processItem($church_array[19]) . "," .
			processItem($church_array[20]) . "," .
			processItem($church_array[21]) . "," .
			processItem($church_array[22]) . "," .
			processItem($church_array[23]) . "," .
			processItem($church_array[24]) . "\n" ;

			$lines .= $line;

		}

		$lines = trim($lines,"\n");


		// Output
		echo $headers . $lines;

?>