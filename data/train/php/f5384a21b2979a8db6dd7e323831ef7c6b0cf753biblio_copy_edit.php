<?php
/**********************************************************************************
 *   Copyright(C) 2002 David Stevens
 *
 *   This file is part of OpenBiblio.
 *
 *   OpenBiblio is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   OpenBiblio is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with OpenBiblio; if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 **********************************************************************************
 */

  $tab = "cataloging";
  $nav = "view";
  $restrictInDemo = true;
  require_once("../shared/common.php");
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
  if (!$copy = $copyQ->query($bibid,$copyid)) {
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
  /*ini franco 11/07/05*/
  $copy->setVolumen($_POST["copyVolumen"]);
  $_POST["copyVolumen"]= $copy->getVolumen();
/*  $copy->setTomo($_POST["copyTomo"]);
  $_POST["copyTomo"]= $copy->getTomo();*/
  $copy->setUserCreador($_POST["copyUsuario"]);
  $_POST["copyUsuario"]= $copy->getUserCreador();
  $copy->setProveedor($_POST["copyProveedor"]);
  $_POST["copyProveedor"]= $copy->getProveedor();
  $copy->setPrecio($_POST["copyPrecio"]);
  $_POST["copyPrecio"]= $copy->getPrecio();    
  $copy->setCodLoc($_POST["copyCodLoc"]);
  $_POST["copyCodLoc"]= $copy->getCodLoc();
  $copy->setDateSptu($_POST["list_year"]."-".$_POST["list_month"]."-".$_POST["list_day"]);
  $_POST["fecha"]= $copy->getDateSptu();      
  /*fin franco*/
  $validData = $copy->validateData();
  if (!$validData) {
    $copyQ->close();
    $pageErrors["barcodeNmbr"] = $copy->getBarcodeNmbrError();
	/*ini franco 11/07/05 */
	$pageErrors["copyPrecio"] = $copy->getPrecioError();
    $pageErrors["fecha"] = $copy->getDateSptuError();
	/*fin franco */
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
  $msg = urlencode($msg);
  header("Location: ../shared/biblio_view.php?bibid=".$bibid."&msg=".$msg);
  exit();
?>
