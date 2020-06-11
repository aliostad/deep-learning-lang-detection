<?php
class Tx_Downloads_Controller_DownloadsController extends Tx_Extbase_MVC_Controller_ActionController  {private $implementation;private function getImplementation() {  if( null == $this->implementation ) {    $this->implementation = new DownloadsDownloadsControllerImplementation($this);  }  return $this->implementation;}function __construct() {parent::__construct();}
/**
* downloadRepository
* @var Tx_Downloads_Domain_Repository_DownloadRepository
*/
protected $downloadRepository;
/**
* injectDownloadRepository
* @param Tx_Downloads_Domain_Repository_DownloadRepository $downloadRepository
*/
public function injectDownloadRepository(Tx_Downloads_Domain_Repository_DownloadRepository $downloadRepository) {
  $this->downloadRepository = $downloadRepository;
}
/**
* downloadCategoryRepository
* @var Tx_Downloads_Domain_Repository_DownloadCategoryRepository
*/
protected $downloadCategoryRepository;
/**
* injectDownloadCategoryRepository
* @param Tx_Downloads_Domain_Repository_DownloadCategoryRepository $downloadCategoryRepository
*/
public function injectDownloadCategoryRepository(Tx_Downloads_Domain_Repository_DownloadCategoryRepository $downloadCategoryRepository) {
  $this->downloadCategoryRepository = $downloadCategoryRepository;
}
/**
* installNoteRepository
* @var Tx_Downloads_Domain_Repository_InstallNoteRepository
*/
protected $installNoteRepository;
/**
* injectInstallNoteRepository
* @param Tx_Downloads_Domain_Repository_InstallNoteRepository $installNoteRepository
*/
public function injectInstallNoteRepository(Tx_Downloads_Domain_Repository_InstallNoteRepository $installNoteRepository) {
  $this->installNoteRepository = $installNoteRepository;
}
/**
* frontendUserRepository
* @var Tx_Extbase_Domain_Repository_FrontendUserRepository
*/
protected $frontendUserRepository;
/**
* injectFrontendUserRepository
* @param Tx_Extbase_Domain_Repository_FrontendUserRepository $frontendUserRepository
*/
public function injectFrontendUserRepository(Tx_Extbase_Domain_Repository_FrontendUserRepository $frontendUserRepository) {
  $this->frontendUserRepository = $frontendUserRepository;
}
/**
* accessRepository
* @var Tx_Downloads_Domain_Repository_AccessRepository
*/
protected $accessRepository;
/**
* injectAccessRepository
* @param Tx_Downloads_Domain_Repository_AccessRepository $accessRepository
*/
public function injectAccessRepository(Tx_Downloads_Domain_Repository_AccessRepository $accessRepository) {
  $this->accessRepository = $accessRepository;
}
/**
*/
public function listAction() { return $this->getImplementation()->listAction(); }
/**
* @param mixed $id
* @param mixed $filename
*/
public function downloadAction($id,$filename) { return $this->getImplementation()->downloadAction($id,$filename); }
}require_once('DownloadsDownloadsControllerImplementation.php');
?>