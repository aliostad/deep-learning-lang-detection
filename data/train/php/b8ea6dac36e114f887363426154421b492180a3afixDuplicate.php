<?php
  require_once("../classes/BiblioCopyQuery.php");
  require_once("../classes/BiblioQuery.php");
  require_once("../classes/BiblioStatusHistQuery.php");

class Layout_fixDuplicate {
  function render($rpt) {
    list($rpt, $errs) = $rpt->variant_el(array('order_by'=>'title'));
    if (!empty($errs)) {
      Fatal::internalError('Unexpected report error');
    }
    
    $copyQ = new BiblioCopyQuery;
    $bibQ = new BiblioQuery;
    $hisQ = new BiblioStatusHistQuery;
    $oldbibid = NULL;
    $oldrow = NULL;
    $sPattern = '/[\s\,\.\;\-]*/m';
    $sReplace = '';
    $comment=NULL;
    while ($row = $rpt->each()) {
      $bibid=$row['bibid'];
      if($oldrow!=NULL) {
        if (strtoupper(preg_replace($sPattern, $sReplace, $row['title'])) != 
        strtoupper(preg_replace($sPattern, $sReplace, $oldrow['title'])) || 
        strtoupper(preg_replace($sPattern, $sReplace, $row['author'] )) != 
        strtoupper(preg_replace($sPattern, $sReplace, $oldrow['author'] ))) {
          $oldbibid = $bibid;
          $oldrow=$row;
        }
        else {
          $copyQ->connect();
          $hisQ->connect();
          if ($copyQ->errorOccurred()) {
            $copyQ->close();
            displayErrorPage($copyQ);
          }
          if (!$copy = $copyQ->execSelect($bibid)) {
            $copyQ->close();
            displayErrorPage($copyQ);
          }         
          while ($copy = $copyQ->fetchCopy()) {
            $refbibid=$copy->getBibid();
            $refcopyid=$copy->getCopyid();
            $oldcopyid=$copyQ->nextCopyid($oldbibid);
            $fields=array();
            $fields=$copyQ->getCustomFields($bibid, $copyid);
            $fields['changes']=$fields['changes']."fr (".$refbibid.",".$refcopyid.") to (".$oldbibid.",".$oldcopyid.") ";
            $copyQ->setCustomFields($oldbibid, $oldcopyid, $fields);
            $fields=NULL;
            $copyQ->setCustomFields($refbibid, $refoldcopyid, $fields);            
            $copy->setBibid($oldbibid);
            $copy->setCopyid($oldcopyid);
            $copyQ->updatebc($copy, $refbibid, $refcopyid);
            $hisQ->updatebc($refbibid, $refcopyid, $oldbibid, $oldcopyid);
            $fields = array();
          }
          if($copyQ->nextCopyid($bibid)=='1') {
            $bibQ->delete($row['bibid']);
          }
          $copyQ->close();
          $hisQ->close();
        }
      }
      else {
        $oldbibid = $bibid;
        $oldrow = $row;
      }
    }
  }
}
?>
