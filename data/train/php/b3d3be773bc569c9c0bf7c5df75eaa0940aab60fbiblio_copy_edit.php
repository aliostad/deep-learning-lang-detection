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
  require_once("../functions/errorFuncs.php");
  require_once("../classes/Localize.php");
  $loc = new Localize(OBIB_LOCALE,$tab);

  #****************************************************************************
  #*  Checking for post vars.  Go back to search if none found.
  #****************************************************************************

  if (count($_POST) == 0) {
    header("Location: ../catalog/index.php");
    exit();
  }
  $bibid = $_POST["bibid"];
  $copyid = $_POST["copyid"];

  #****************************************************************************
  #*  Ready copy record
  #****************************************************************************
  $copyQ = new BiblioCopyQuery();
  $copyQ->connect();
  if ($copyQ->errorOccurred()) {
    $copyQ->close();
    displayErrorPage($copyQ);
  }
  if (!$copy = $copyQ->doQuery($bibid,$copyid)) {
    $copyQ->close();
    displayErrorPage($copyQ);
  }

  #****************************************************************************
  #*  Validate data
  #****************************************************************************
  $copy->setCopyDesc($_POST["copyDesc"]);
  $_POST["copyDesc"] = $copy->getCopyDesc();
  $copy->setBarcodeNmbr($_POST["barcodeNmbr"]);
  $_POST["barcodeNmbr"] = $copy->getBarcodeNmbr();
  $copy->setStatusCd($_POST["statusCd"]);
  $_POST["statusCd"] = $copy->getStatusCd();
  $validData = $copy->validateData();
  if (!$validData) {
    $copyQ->close();
    $pageErrors["barcodeNmbr"] = $copy->getBarcodeNmbrError();
    $_SESSION["postVars"] = $_POST;
    $_SESSION["pageErrors"] = $pageErrors;
    header("Location: ../catalog/biblio_copy_edit_form.php");
    exit();
  }

  #**************************************************************************
  #*  Edit bibliography copy
  #**************************************************************************
  if (!$copyQ->update($copy)) {
    $copyQ->close();
    if ($copyQ->getDbErrno() == "") {
      $pageErrors["barcodeNmbr"] = $copyQ->getError();
      $_SESSION["postVars"] = $_POST;
      $_SESSION["pageErrors"] = $pageErrors;
      header("Location: ../catalog/biblio_copy_edit_form.php");
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

  $msg = $loc->getText("biblioCopyEditSuccess");
  header("Location: ../shared/biblio_view.php?bibid=".U($bibid)."&msg=".U($msg));
  exit();
?>
