<?php 

/**
 * 1.) Changed the shared key.
 * 2.) Upload to the root of your ekklesia360 web directory.
 * 3.) Go to the import tab in Message Manager and input the url to the uploaded file and your key.
 * 4.) Press Being Import... sit back and relex.
 */

$shared_key = 'SOME_SHARED_KEY';

/* ****************************************** */
/* there should be no need to edit below here */
/* ****************************************** */

// check the request
if (empty($_REQUEST['value']) || empty($_REQUEST['enc_value']) || $shared_key == 'SOME_SHARED_KEY' || (sha1($_REQUEST['value'].sha1($shared_key)) != $_REQUEST['enc_value'])) {
	header('HTTP/1.1 403 Forbidden');
	die ("BAD REQUEST");
}

$item_delimiter = "~|MessageManager|~";
$line_delimiter = "~|~MessageManager~|~";


require($_SERVER['DOCUMENT_ROOT'] . '/monkcms.php');

header("Content-Type: plain/text");
header("Content-Transfer-Encoding: binary");
header("Pragma: no-cache");
header("Expires: 0");

getContent(
	"sermon",
	"display:list",
	"howmany:".$howmany,
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
?>