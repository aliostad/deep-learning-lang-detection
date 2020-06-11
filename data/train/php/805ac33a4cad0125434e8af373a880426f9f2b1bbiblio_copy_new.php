<?php
/* This file is part of a copyrighted work; it is distributed with NO WARRANTY.
 * See the file COPYRIGHT.html for more details.
 */
 
  require_once("../shared/common.php");
  $tab = "cataloging";
  $nav = "view";
  $restrictInDemo = true;
  require_once("../shared/logincheck.php");

  require_once("../classes/BiblioCopy.php");
  require_once("../classes/BiblioCopyQuery.php");
  require_once("../classes/DmQuery.php");
  require_once("../functions/errorFuncs.php");
  require_once("../classes/Localize.php");
  $loc = new Localize(OBIB_LOCALE,$tab);

  #****************************************************************************
  #*  Checking for post vars.  Go back to form if none found.
  #****************************************************************************

  if (count($_POST) == 0) {
    header("Location: ../catalog/biblio_new.php");
    exit();
  }

  $copyQ = new BiblioCopyQuery();
  $copyQ->connect();
  if ($copyQ->errorOccurred()) {
    $copyQ->close();
    displayErrorPage($copyQ);
  }
  #****************************************************************************
  #*  Autobarco
  #*
  #* FIXME RACE: User A and User B each try to insert a copy concurrently. 
  #* User A's process gets next copy id, then checks for a duplicate barcode,
  #* Before the final insert, though, User B's process asks for the next copy id
  #* and checks for a duplicate barcode.  At that point, both inserts will succeed
  #* and two copies will have the same barcode.  Several different interleavings
  #* either cause the duplicate barcode check to fail or cause duplicate barcodes
  #* to be entered.  This can be fixed with a lock or by an atomic
  #* get-and-increment-sequence-value operation.  I'll fix it later. -- Micah
  #****************************************************************************
  if (isset($_POST["autobarco"]) and $_POST["autobarco"]) {
    $nzeros = "5";
    $bibid=$_POST["bibid"];
    $CopyNmbr = $copyQ->nextCopyid($bibid);
    if ($copyQ->errorOccurred()) {
      $copyQ->close();
      displayErrorPage($copyQ);
    }
    $_POST["barcodeNmbr"] = sprintf("%0".$nzeros."s",$bibid).$CopyNmbr;
  }

  #****************************************************************************
  #*  Validate data
  #****************************************************************************
  $bibid=$_POST["bibid"];
  $copy = new BiblioCopy();
  $copy->setBibid($bibid);
  $copy->setCopyDesc($_POST["copyDesc"]);
  $_POST["copyDesc"] = $copy->getCopyDesc();
  $copy->setBarcodeNmbr($_POST["barcodeNmbr"]);
  $_POST["barcodeNmbr"] = $copy->getBarcodeNmbr();
  
  $dmQ = new DmQuery();
  $dmQ->connect();
  $customFields = $dmQ->getAssoc('biblio_copy_fields_dm');
  $dmQ->close();
  foreach ($customFields as $name => $title) {
    if (isset($_REQUEST['custom_'.$name])) {
      $copy->setCustom($name, $_REQUEST['custom_'.$name]);
    }
  }
  
  $validBarco = $_POST["validBarco"];
  $validData = $copy->validateData($validBarco);
  if (!$validData) {
    $pageErrors["barcodeNmbr"] = $copy->getBarcodeNmbrError();
    $_SESSION["postVars"] = $_POST;
    $_SESSION["pageErrors"] = $pageErrors;
    header("Location: ../catalog/biblio_copy_new_form.php?bibid=".U($bibid));
    exit();
  }

  #**************************************************************************
  #*  Insert new bibliography copy
  #**************************************************************************
  if (!$copyQ->insert($copy)) {
    $copyQ->close();
    if ($copyQ->getDbErrno() == "") {
      $pageErrors["barcodeNmbr"] = $copyQ->getError();
      $_SESSION["postVars"] = $_POST;
      $_SESSION["pageErrors"] = $pageErrors;
      header("Location: ../catalog/biblio_copy_new_form.php?bibid=".U($bibid));
      exit();
    } else {
      displayErrorPage($copyQ);
    }
  }
  $copyQ->close();

  #**************************************************************************
  #*  Destroy form values and errors
  #**************************************************************************
  unset($_SESSION["postVars"]);
  unset($_SESSION["pageErrors"]);

  $msg = $loc->getText("biblioCopyNewSuccess");
  header("Location: ../shared/biblio_view.php?bibid=".U($bibid)."&msg=".U($msg));
  exit();
?>
