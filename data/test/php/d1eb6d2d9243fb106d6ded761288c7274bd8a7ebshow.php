<?php

if (!isset($perma)){
    header("Location: $baseurl");
    exit();
}

$perma = str_replace("/","",$perma);

$show_data = $show->getShowByPerma($perma, $language);

if (count($show_data)){    
    foreach($show_data as $show_id => $val){
        extract($val);
        
        $show_data[$show_id]['description'] = nl2br($val['description']);
        
        $show_data[$show_id]['categories'] = $show->getShowCategories($show_id, true, $language);
        
        $seodata['showtitle'] = $val['title'];
        $seodata['title'] = $val['title'];
        $seodata['description'] = $val['description'];
        
        $smarty->assign("fb_image",$baseurl."/thumbs/".$show_data[$show_id]['thumbnail']);
        
        $show_seasons = $show->getSeasons($show_id);
        if (!count($show_seasons)) {
            $show_seasons = '';
        }
        $smarty->assign("show_seasons",$show_seasons);
        $show_title = $title;
    }
    
    if (!isset($season)){
        $season = null;
    }
    
    if (isset($season) && $season){
        $seodata['season'] = $season;
        $smarty->assign("season",$season);
    } else {
        $smarty->assign("season","");
    }
    
    if ($logged){
        $user = new User();
        if (!isset($_SESSION['loggeduser_seen_episodes'])){
            $seen = $user->getSeenEpisodes(null,true);
        } else {
            $seen = $_SESSION['loggeduser_seen_episodes'];
        }
    } else {
        $seen = array();
    }
    
    $episodes = $show->getEpisodes($show_id,$season,$language);
    if (count($episodes)){
        foreach($episodes as $episode_id => $val){
            extract($val);
            
            $description = nl2br($description);
            if (substr_count($description,"Airdate:")){
                $tmp = explode("<br />",$description);
                $description = $tmp[2];
            }
            
            $episodes[$episode_id]['description'] = $description;
            $episodes[$episode_id]['perma'] = $perma;
            
            if (in_array($episode_id,$seen)){
                $episodes[$episode_id]['seen'] = 1;
            } else {
                $episodes[$episode_id]['seen'] = 0;
            }
        }
    }
    
} else {
    $show_data = '';
    $episodes = '';
}

if ($global_settings['seo_links']){
    $smarty->assign("fullurl",$baseurl."/".$routes['show']."/".$perma);
} else {
    $smarty->assign("fullurl",$baseurl."/index.php?menu=show&perma=".$perma);
}

$smarty->assign("show_data",$show_data);
$smarty->assign("episodes",$episodes);
?>