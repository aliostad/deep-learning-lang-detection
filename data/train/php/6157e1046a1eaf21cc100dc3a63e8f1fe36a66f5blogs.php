<? require($_SERVER["DOCUMENT_ROOT"]."/monkcms.php"); 


$outarray; 
$nodes;
$category;
$blogname;
$group;
$json;
$output;

$category = $_GET['category'];
$group = $_GET['group'];
$blogname = $_GET['blogname']; 

$string = getContent(  
		"blog",
        "display:list",
        "order:recent",
        "name:".$blogname,
        "find_category:".$category,
        "find_group:".$group,
        "howmany:100",  
		"show_postlist:__blogposttitle__",
		"show_postlist:||",
		"show_postlist:__blogsummary__",
		"show_postlist:||",
		"show_postlist:__preview limit='200'__",
		"show_postlist:||",
		"show_postlist:__blogauthor__",
		"show_postlist:||",
		"show_postlist:__blogpostdate format='M d Y'__",
		"show_postlist:||",
		"show_postlist:__blogtext__",
		"show_postlist:||",
		"show_postlist:__blogpostslug__",
		"show_postlist:||",
		"show_postlist:__blogpostpermalink__",
		"show_postlist:||",
		"show_postlist:__imageurl__",
		"show_postlist:~~",
		"noecho"
	); 
	 
   //echo($string);
	
	$prearray = explode("~~",$string);
	
	for ($i=0; $i <count($prearray)-1; $i++) { 
    	
		 $outarray[$i] = explode("||",$prearray[$i]);
    }
      $i = 0;
	foreach ($outarray as $key => $value) {
	     $nodes[$i] = array(
	         
		    title => $value[0],
		    summary => $value[1],
		    preview => $value[2],
		    author => $value[3],
		    date => $value[4],
		    text => $value[5],
		    slug => $value[6],
		    link => $value[7],
		    image=> $value[8]
		    );
		    $i++;
	}
	
	$output = array( items => $nodes);
	
	//$output = array("items" => $nodes);
	
	$json = json_encode($output);
	//print_r($articles); 
	
	 $callback = $_REQUSEST['callback'];
	 
	 if($callback){
	     header('Content-type: text/javascript');
	     echo $callback . '(' . $json . ');';
	 }else{
	     header('Content-type: application/json');
	     echo $json; 
	 }
	
?>