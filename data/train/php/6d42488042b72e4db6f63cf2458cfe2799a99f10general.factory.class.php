<?php
! defined ( 'CLOUDWIND' ) && exit ( 'Forbidden' );
class CloudWind_General_Factory {
	var $_service = array ();
	
	function getGeneralThreadService() {
		if (! $this->_service ['GeneralThreadService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.thread.class.php';
			$this->_service ['GeneralThreadService'] = new CloudWind_Search_General_Thread ();
		}
		return $this->_service ['GeneralThreadService'];
	}
	
	function getGeneralPostService() {
		if (! $this->_service ['GeneralPostService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.post.class.php';
			$this->_service ['GeneralPostService'] = new CloudWind_Search_General_Post ();
		}
		return $this->_service ['GeneralPostService'];
	}
	
	function getGeneralMemberService() {
		if (! $this->_service ['GeneralMemberService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.member.class.php';
			$this->_service ['GeneralMemberService'] = new CloudWind_Search_General_Member ();
		}
		return $this->_service ['GeneralMemberService'];
	}
	
	function getGeneralDiaryService() {
		if (! $this->_service ['GeneralDiaryService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.diary.class.php';
			$this->_service ['GeneralDiaryService'] = new CloudWind_Search_General_Diary ();
		}
		return $this->_service ['GeneralDiaryService'];
	}
	
	function getGeneralColonyService() {
		if (! $this->_service ['GeneralColonyService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.colony.class.php';
			$this->_service ['GeneralColonyService'] = new CloudWind_Search_General_Colony ();
		}
		return $this->_service ['GeneralColonyService'];
	}
	
	function getGeneralForumService() {
		if (! $this->_service ['GeneralForumService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.forum.class.php';
			$this->_service ['GeneralForumService'] = new CloudWind_Search_General_Forum ();
		}
		return $this->_service ['GeneralForumService'];
	}
	
	function getGeneralAttachService() {
		if (! $this->_service ['GeneralAttachService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.attach.class.php';
			$this->_service ['GeneralAttachService'] = new CloudWind_Search_General_Attach ();
		}
		return $this->_service ['GeneralAttachService'];
	}
	
	function getGeneralWeiboService() {
		if (! $this->_service ['GeneralWeiboService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.weibo.class.php';
			$this->_service ['GeneralWeiboService'] = new CloudWind_Search_General_Weibo ();
		}
		return $this->_service ['GeneralWeiboService'];
	}
	
	function getGeneralToolsService() {
		if (! $this->_service ['GeneralToolsService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.tools.class.php';
			$this->_service ['GeneralToolsService'] = new CloudWind_General_Tools ();
		}
		return $this->_service ['GeneralToolsService'];
	}
	
	function getGeneralLogsService() {
		if (! $this->_service ['GeneralLogsService']) {
			require_once CLOUDWIND . '/client/search/general/service/general.logs.class.php';
			$this->_service ['GeneralLogsService'] = new CloudWind_General_Logs ();
		}
		return $this->_service ['GeneralLogsService'];
	}
}