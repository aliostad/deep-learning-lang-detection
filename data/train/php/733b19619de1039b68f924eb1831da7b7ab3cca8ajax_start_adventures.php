<?php 
    require("application.php");
    
    if ($_SESSION["belepve"] == 1) {
        // csak belepett user indithat!
        
        if (get_magic_quotes_gpc()) {
            $_POST["karakterek"] = stripslashes($_POST["karakterek"]);
            $_POST["terkep"] = stripslashes($_POST["terkep"]);
        }
        
        

        
        // elmentjuk az elso savet!
        $save = new SaveGame($_SESSION["felhasznalo_id"]);
        $save->elso_mentes();
        $save->setKarakterek($_POST["karakterek"]);
        $save->setTerkep($_POST["terkep"]);
        
        $save->mentes();
        echo "1"; 
    } else {
        echo "0";
    }



    
?>