<?php
    
    include ('../lib/frontend/core.php');
    
    if(isset($_GET['show']) && !isset($_GET['season'])){
        $tv_show    = $db->load_object_by_id('tv_shows',$_GET['show']);
        $seasons    = $db->load_seasons($_GET['show']);
        $episodes   = $db->load_objects_by_column('tv_files','show_id',$_GET['show'],'season_num,episode_num');
        $page       = 'show.php';
    }elseif(isset($_GET['show']) && isset($_GET['season'])){
        $tv_show    = $db->load_object_by_id('tv_shows',$_GET['show']);
        $seasons    = $db->load_seasons($_GET['show']);
        $episodes   = $db->load_season($_GET['show'],$_GET['season']);
        $page       = 'show.php';
    }else{
        $tv_shows   = $db->load_all_objects('tv_shows',array('id','banner'),'show_name');
        $page       = 'dashboard.php';
    }

    $themepath = 'themes/'.$theme.'/';
    include($themepath.'index.php');
    
?>