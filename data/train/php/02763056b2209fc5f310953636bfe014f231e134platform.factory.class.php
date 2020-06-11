<?php
! defined ( 'CLOUDWIND' ) && exit ( 'Forbidden' );
class CloudWind_Platform_Factory {
	var $_service = array ();
	function getControlService() {
		if (! $this->_service ['ControlService']) {
			require_once CLOUDWIND . '/client/platform/service/platform.control.class.php';
			$this->_service ['ControlService'] = new CloudWind_Platform_Control ();
		}
		return $this->_service ['ControlService'];
	}
	
	function getSettingService() {
		if (! $this->_service ['SettingService']) {
			require_once CLOUDWIND . '/client/platform/service/platform.setting.class.php';
			$this->_service ['SettingService'] = new CloudWind_Platform_Setting ();
		}
		return $this->_service ['SettingService'];
	}
	
	function getVerifySettingService() {
		if (! $this->_service ['VerifySettingService']) {
			require_once CLOUDWIND . '/client/platform/service/platform.verifysetting.class.php';
			$this->_service ['VerifySettingService'] = new CloudWind_Platform_VerifySetting ();
		}
		return $this->_service ['VerifySettingService'];
	}
	
	function getCheckServerService() {
		if (! $this->_service ['CheckServerService']) {
			require_once CLOUDWIND . '/client/platform/service/platform.checkserver.class.php';
			$this->_service ['CheckServerService'] = new CloudWind_Platform_CheckServer ();
		}
		return $this->_service ['CheckServerService'];
	}
	
	function getApplyService() {
		if (! $this->_service ['ApplyService']) {
			require_once CLOUDWIND . '/client/platform/service/platform.apply.class.php';
			$this->_service ['ApplyService'] = new CloudWind_Platform_Apply ();
		}
		return $this->_service ['ApplyService'];
	}

	function getSyncService() {
		if (! $this->_service ['SyncService']) {
			require_once CLOUDWIND . '/client/platform/service/platform.sync.class.php';
			$this->_service ['SyncService'] = new CloudWind_Platform_Sync ();
		}
		return $this->_service ['SyncService'];
	}
	
	function getWalkerService() {
		if (! $this->_service ['WalkerService']) {
			require_once CLOUDWIND . '/client/platform/service/platform.walker.class.php';
			$this->_service ['WalkerService'] = new CloudWind_Platform_Walker ();
		}
		return $this->_service ['WalkerService'];
	}
}