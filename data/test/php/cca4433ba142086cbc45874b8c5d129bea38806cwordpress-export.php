<?php 

/**
 * 1.) Changed the shared key.
 * 2.) Upload to the root of your ekklesia360 web directory.
 * 3.) Go to Tools -> Ekklesia 360 Importer and follow the directions.
 */

/* Export script derived from scripts at https://raw.github.com/MonkDev/monkcms-snippets/master/Export */

$shared_key = 'SOME_SHARED_KEY';

/* ****************************************** */
/* there should be no need to edit below here */
/* ****************************************** */

$check_key = true;

if (empty($_REQUEST['rand']) || empty($_REQUEST['enc']) || empty($_REQUEST['what'])) {
	header('HTTP/1.1 400 Bad Request');
	die('Invalid request parameters.');
}

$rand = $_REQUEST['rand']; $enc = $_REQUEST['enc']; $what = $_REQUEST['what'];

if ($check_key) {
	if ($shared_key == 'SOME_SHARED_KEY') {
		header('HTTP/1.1 403 Forbidden');
		die("You must change the shared key.");
	}

	if ($enc != sha1($rand.$what.sha1($shared_key))) {
		header('HTTP/1.1 403 Forbidden');
		die("Invalid shared key or tampered data.");
	}
}

$item_delimiter = '~|EKIMPITEM|~';
$line_delimiter = '~|~EKIMPLINE~|~';

require($_SERVER['DOCUMENT_ROOT'] . '/monkcms.php');

header("Content-Type: plain/text");
header("Content-Transfer-Encoding: binary");
header("Pragma: no-cache");
header("Expires: 0");

/************* PAGES *************/
if ($what == 'pages') {
	// Find page ID's
	$htaccess = file_get_contents('.htaccess');
	preg_match_all('/nav=p-(.*?)\&/',$htaccess,$matches);
	$pageIDs = $matches[1];

	// Process lines
	for($i=0;$i<count($pageIDs);$i++){
		getContent(
				"page",
				"find:p-" . $pageIDs[$i],
				"show:". $pageIDs[$i],
				"show:$item_delimiter",
				"show:__title__",
				"show:$item_delimiter",
				"show:__slug__",
				"show:$item_delimiter",
				"show:__url__",
				"show:$item_delimiter",
				"show:__groupslug__",
				"show:$item_delimiter",
				"show:__description__",
				"show:$item_delimiter",
				"show:__tags__",
				"show:$item_delimiter",
				"show:__text__",
				"show:$line_delimiter"
		);
	}
}

/************* ARTICLES *************/
if ($what == 'articles') {
	getContent(
			"article",
			"display:list",
			"show:__id__",
			"show:$item_delimiter",
			"show:__title__",
			"show:$item_delimiter",
			"show:__slug__",
			"show:$item_delimiter",
			"show:__category__",
			"show:$item_delimiter",
			"show:__url__",
			"show:$item_delimiter",
			"show:__text__",
			"show:$item_delimiter",
			"show:__summary__",
			"show:$item_delimiter",
			"show:__tags__",
			"show:$item_delimiter",
			"show:__group__",
			"show:$item_delimiter",
			"show:__date format='Y-m-d H:i:s'__",
			"show:$item_delimiter",
			"show:__author__",
			"show:$item_delimiter",
			"show:__imageurl__",
			"show:$line_delimiter"
	);
}

/************* MENUS *************/
if ($what == 'menus') {

	$clean = '~|EKIMPCLEAN|~';

	$raw_items = getContent(
			"navigation",
			"display:dropdown",
			"show:$clean",
			"show:__id__",
			"show:$item_delimiter",
			"show:__level__",
			"show:$item_delimiter",
			"show:__title__",
			"show:$item_delimiter",
			"show:__pagetitle__",
			"show:$item_delimiter",
			"show:__url__",
			"show:$item_delimiter",
			"show:__description__",
			"show:$item_delimiter",
			"show:__ifnewwindow__true",
			"show:$line_delimiter",
			"show:$clean",
			"noecho"
	);

	$dirty_items = explode($clean, $raw_items);

	$clean_items = array();
	foreach ($dirty_items as $value) {
		if (strstr($value, $item_delimiter) !== false) {
			echo $value;
		}
	}
}

/************ MESSAGES ***********/
if ($what == 'messages') {
	getContent(
			"sermon",
			"display:list",
			"howmany:9999",
			"order:recent",
			"show:__id__",
			"show:$item_delimiter",
			"show:__title__",
			"show:$item_delimiter",
			"show:__date format='Y-m-d H:i:s'__",
			"show:$item_delimiter",
			"show:__category__",
			"show:$item_delimiter",
			"show:__series__",
			"show:$item_delimiter",
			"show:__seriesdescription__",
			"show:$item_delimiter",
			"show:__seriesimage__",
			"show:$item_delimiter",
			"show:__preacher__",
			"show:$item_delimiter",
			"show:__preacherslug__",
			"show:$item_delimiter",
			"show:__preacherdesc__",
			"show:$item_delimiter",
			"show:__preacherimage__",
			"show:$item_delimiter",
			"show:__passagebook__",
			"show:$item_delimiter",
			"show:__passageverse__",
			"show:$item_delimiter",
			"show:__summary__",
			"show:$item_delimiter",
			"show:__tags__",
			"show:$item_delimiter",
			"show:__text__",
			"show:$item_delimiter",
			"show:__audiourl__",
			"show:$item_delimiter",
			"show:__videourl__",
			"show:$item_delimiter",
			"show:__videoembed__",
			"show:$item_delimiter",
			"show:__imageurl__",
			"show:$item_delimiter",
			"show:__notes__",
			"show:$item_delimiter",
			"show:__featured__",
			"show:$line_delimiter"
	);
}

die();