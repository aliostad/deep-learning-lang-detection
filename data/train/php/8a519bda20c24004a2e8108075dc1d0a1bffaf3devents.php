<? require($_SERVER["DOCUMENT_ROOT"]."/monkcms.php"); 

$outarray; 
$nodes;
$category;
$group;
$json;

$category = $_GET['category'];
$group = $_GET['group']; 

$string = getContent(  
		"event",
        "display:list",
        "find_category:".$category,
        "find_group:".$group,
        "howmany:25",  
		"show:__title__",
		"show:||",
		"show:__image__",
		"show:||",
		"show:__preview limit='200'__",
		"show:||",
	    "show:__description__",
    	"show:||",
		"show:__coordname__",
		"show:||",
		"show:__coordemail__",
		"show:||",
		"show:__coordphone__",
		"show:||",
		"show:__eventstart format='M d Y'__",
		"show:||",
		"show:__eventstartTwo format='M'__",
		"show:||",
		"show:__eventstartThree format='d'__",
		"show:||",
		"show:__eventend format='M d Y'__",
		"show:||",
		"show:__eventtimes__",
		"show:||",
		"show:__googlemap__",
		"show:||",
		"show:__fulladdress__",
		"show:||",
		"show:__location__",
		"show:||",
		"show:__slug__",
		"show:||",
		"show:__registration linktext='Register'__",
		"show:~~",
		"noecho"
	); 
	 
   //echo($string);
	
	$prearray = explode("~~",$string);
	
	for ($i=0; $i <count($prearray)-1; $i++) { 
    	
		 $outarray[$i] = explode("||",$prearray[$i]);
    }
    //generate json structure
    $i = 0;
	foreach ($outarray as $key => $value) {
	     $nodes[$i] = array(
		    title => $value[0],
		    image => $value[1],
		    preview => $value[2],
		    text => $value[3],
		    date => array(  
	               startDate => $value[7],
	               month => $value[8],
	               day => $value[9],
	               end => $value[10],
	               times => $value[11]
	            ),    
		    coord => array(
		            name => $value[4],
		            email => $value[5],
		            phone => $value[6]
		        ),
		    loc => array(
		            name => $value[14],
		            address => $value[13],
		            googlemap => $value[12]
		        ),
		    slug => $value[15],
		    register => $value[16]
		    );
	    $i++;
	}
	
	//$output = array("items" => $nodes);
	
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