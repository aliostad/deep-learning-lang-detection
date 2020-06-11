<?php 
    require("application.php");
    
    if ($_SESSION["belepve"] == 1) {
        // csak belepett user indithat!
        
        // elmentjuk
        $save = new SaveGame($_SESSION["felhasznalo_id"]);
        $save->setKarakterek($_POST["karakterek"]);
        $save->setTerkep($_POST["terkep"]);
        $save->setNpck($_POST["npck"]);
        
        $iid = $save->mentes();
        
        //file_put_contents("c:/wamp/www/eyeofthespider/". $_SESSION["felhasznalo_id"] . "_" . $iid .".png",$_POST["screen"]);

        
        echo "1"; 
    } else {
        echo "0";
    }



    
?>