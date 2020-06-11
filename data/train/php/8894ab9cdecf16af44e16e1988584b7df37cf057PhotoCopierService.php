<?php

class PhotoCopierService {
    public function doPhotoCopy(PhotoCopy $photoCopy){
        $this->normalizeDirectories($photoCopy);
        $src = $photoCopy->srcPath . "\\" . $photoCopy->photoName;
        $dest = $photoCopy->destPath . "\\" . $photoCopy->photoName;
        if (!file_exists($photoCopy->destPath)){
            mkdir($photoCopy->destPath, 0777, true);
        }
        $kioskJobDao = new KioskJobDao();
        $kioskJobDao->addJob(sprintf("%s \"%s\" \"%s\"", COPY_COMMAND, addslashes($src), addslashes($dest)));
        return true;
    }
    
    protected function normalizeDirectories($photoCopy){
        $src = $photoCopy->srcPath;
        $dest = $photoCopy->destPath;
        $newSrc = preg_replace("/(.*)\\$/", "$1", $src);
        $newDest = preg_replace("/(.*)\\$/", "$1", $dest);
        $photoCopy->srcPath = $newSrc;
        $photoCopy->destPath = $newDest;
    }
}

?>
