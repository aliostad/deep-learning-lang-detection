<?php
/*$save_location="/home/coding/OG/problist/DB/10427/";
deleting($save_location);
function deleting($save_location){
    foreach(scandir($save_location) as $file) {
        if ('.' === $file || '..' === $file) continue;
        if (is_dir("$save_location/$file")) deleting("$save_location/$file");
        else unlink("$save_location/$file");
    }
    rmdir($save_location);
    mkdir($save_location);
}*/
    require_once("db.php");
    $link = db_open();
    $dbtable = "id10400";
    echo table_check($dbtable,$link);
    db_close($link);
?>

