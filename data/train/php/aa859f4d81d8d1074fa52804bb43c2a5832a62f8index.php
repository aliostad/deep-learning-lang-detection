<?php
$pixDumpLink = "http://www.tcmag.com/magazine/pix_dump_";
$page = file_get_contents("http://www.tcmag.com/");

// Liste des adresses email destinataires
$destinataireArray = array();
$destinataire = implode(",", $destinataireArray);

$fic = fopen("pixDump.txt","a+");
$lastPixDump = fgets($fic,1024);
fclose($fic);

if (preg_match_all("#href=\"(http://www.tcmag.com/magazine/pix_dump_[0-9]{2,5})#", $page, $matches)){
	if (sizeof($matches[1]) > 0) {
		$newPixDump = false;
		foreach ($matches[1] as $lien) {
			$nbPixDump = strrchr($lien, "_");
			$nbPixDump = str_replace("_", "", $nbPixDump);
			if ($nbPixDump > $lastPixDump) {
				$newPixDump = true;
				$message = 'Un nouveau Pix Dump est disponible: '.$pixDumpLink.''.$nbPixDump;
				if (mail($destinataire, "[PERSO] Nouveau Pix Dump: ".$nbPixDump, $message)){
					$fic = fopen("pixDump.txt","w+");
					fputs($fic, $nbPixDump);
					fclose($fic);
					echo 'Un nouveau Pix Dump est disponible: Pix Dump #'.$nbPixDump;
				}
				break;
			}
		}
	}
}
if (!$newPixDump) {
	echo "Pas de nouvelle version de Pix Dump.\r\nDerniere verion: Pix Dump #".$lastPixDump;
}
?>