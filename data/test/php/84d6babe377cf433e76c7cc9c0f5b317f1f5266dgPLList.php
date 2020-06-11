<?php

require_once dirname(__FILE__) . '/SpinPapiConf.inc.php';


// Instantiate our client object.
$sp = new SpinPapiClient($mySpUserID, $mySpSecret, $myStation, true);

// Initialize the cache according to the config file.
if (isset($myFCache)) {
	$sp->fcInit($myFCache);
}
if (isset($myMemcache)) {
	$sp->mcInit($myMemcache);
}

function e($s) { 
  return htmlspecialchars($s);
}

$UserID=$_REQUEST['UserID'];
$ShowID=$_REQUEST['ShowID'];
//
//$TestUserID='45';
//$TestShowID='256';
//$UserID=$TestUserID;
//$ShowID=$TestShowID;
        
$showPl = $sp->query(array(
    'method' => 'getPlaylistsInfo',
    'UserID'=>$UserID,
    'ShowID' => $ShowID,
    'Num'=>'99'
    ));

if($showPl[results]!='')
{
   $showSongs= $sp->query(array(
    'method' => 'getSongs',
    'PlaylistID'=>$showPl[results][0][PlaylistID]
    ));
$showSongs=$showSongs[results];

//echo("<pre>");
//print_r($showSongs[20]);
//echo("</pre>");

//$LimitSongs=7;
        if($showSongs!='')
        {
         $echoString='{"SongsList":[';
        for ( $i=0;$i<count($showSongs);$i++)//count($showSongs)$LimitSongs
        {
            $showSongs[$i][SongName]=str_replace('"', '&quot;',$showSongs[$i][SongName]);  
            $showSongs[$i][Sequence]=str_replace('"', '&quot;',$showSongs[$i][Sequence]);
            $showSongs[$i][Timestamp]=str_replace('"', '&quot;',$showSongs[$i][Timestamp]);
            $showSongs[$i][LabelWebsite]=str_replace('"', '&quot;',$showSongs[$i][LabelWebsite]);
            $showSongs[$i][SongNote]=str_replace('"', '&quot;',$showSongs[$i][SongNote]);
            $showSongs[$i][ArtistName]=str_replace('"', '&quot;',$showSongs[$i][ArtistName]);
            $showSongs[$i][DiskName]=str_replace('"', '&quot;',$showSongs[$i][DiskName]);
            
            $rowString=$rowString.'{"SongID":"'.$showSongs[$i][SongID].'","Sequence":"'.$showSongs[$i][Sequence].
                    '","PlaylistID":"'.$showSongs[$i][PlaylistID].'","ShowID":"'.$showSongs[$i][ShowID].'","Date":"'.$showSongs[$i][Date].
                    '","Timestamp":"'.$showSongs[$i][Timestamp].'","ArtistName":"'.$showSongs[$i][ArtistName].'","SongName":"'.$showSongs[$i][SongName].
                    '","SongNote":"'.$showSongs[$i][SongNote].'","DiskName":"'.$showSongs[$i][DiskName].'","DiskFormat":"'.$showSongs[$i][DiskFormat].
                    '","DiskType":"'.$showSongs[$i][DiskType].'","LabelWebsite":"'.$showSongs[$i][LabelWebsite].'","LabelCountry":"'.$showSongs[$i][LabelCountry].
                    '","LabelFlag":"'.$showSongs[$i][LabelFlag].'","RequestFlag":"'.$showSongs[$i][RequestFlag].'","NewFlag":"'.$showSongs[$i][NewFlag].'"}';
            if($i!=count($showSongs)-1)//$LimitSongs$LimitSongs
            {
                $rowString=$rowString.',';
            }
        }

        $echoString=$echoString.$rowString.']}';
        echo $echoString;
        }
        else
            { 
         $echoString='{"SongsList":[]}';
         echo $echoString; 

         }
    
}
 else { 
 $echoString='{"SongsList":[]}';
 echo $echoString; 
     
 }

  ?>