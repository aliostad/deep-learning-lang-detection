<?php
! defined ( 'CLOUDWIND' ) && exit ( 'Forbidden' );
class CloudWind_Service_Factory {
	var $_service = array ();
	
	function getSearchThreadService() {
		if (! $this->_service ['SearchThreadService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.thread.class.php';
			$this->_service ['SearchThreadService'] = new CloudWind_Search_Thread ();
		}
		return $this->_service ['SearchThreadService'];
	}
	
	function getSearchPostService() {
		if (! $this->_service ['SearchPostService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.post.class.php';
			$this->_service ['SearchPostService'] = new CloudWind_Search_Post ();
		}
		return $this->_service ['SearchPostService'];
	}
	
	function getSearchWeiboService() {
		if (! $this->_service ['SearchWeiboService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.weibo.class.php';
			$this->_service ['SearchWeiboService'] = new CloudWind_Search_Weibo ();
		}
		return $this->_service ['SearchWeiboService'];
	}
	
	function getSearchMemberService() {
		if (! $this->_service ['SearchMemberService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.member.class.php';
			$this->_service ['SearchMemberService'] = new CloudWind_Search_Member ();
		}
		return $this->_service ['SearchMemberService'];
	}
	
	function getSearchForumService() {
		if (! $this->_service ['SearchForumService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.forum.class.php';
			$this->_service ['SearchForumService'] = new CloudWind_Search_Forum ();
		}
		return $this->_service ['SearchForumService'];
	}
	
	function getSearchDiaryService() {
		if (! $this->_service ['SearchDiaryService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.diary.class.php';
			$this->_service ['SearchDiaryService'] = new CloudWind_Search_Diary ();
		}
		return $this->_service ['SearchDiaryService'];
	}
	
	function getSearchColonyService() {
		if (! $this->_service ['SearchColonyService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.colony.class.php';
			$this->_service ['SearchColonyService'] = new CloudWind_Search_Colony ();
		}
		return $this->_service ['SearchColonyService'];
	}
	
	function getSearchAttachService() {
		if (! $this->_service ['SearchAttachService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.attach.class.php';
			$this->_service ['SearchAttachService'] = new CloudWind_Search_Attach ();
		}
		return $this->_service ['SearchAttachService'];
	}
	
	function getDefendGeneralOperateService() {
		if (! $this->_service ['DefendGeneralOperateService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/defend.generaloperate.class.php';
			$this->_service ['DefendGeneralOperateService'] = new CloudWind_Defend_General_Operate ();
		}
		return $this->_service ['DefendGeneralOperateService'];
	}
	
	function getDefendPostVerifyService() {
		if (! $this->_service ['DefendPostVerifyService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/defend.postverify.class.php';
			$this->_service ['DefendPostVerifyService'] = new CloudWind_Defend_PostVerify ();
		}
		return $this->_service ['DefendPostVerifyService'];
	}
	
	function getSearchSyncService() {
		if (! $this->_service ['SearchSyncService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.sync.class.php';
			$this->_service ['SearchSyncService'] = new CloudWind_Search_Sync ();
		}
		return $this->_service ['SearchSyncService'];
	}
	
	function getDefendSyncService() {
		if (! $this->_service ['DefendSyncService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/defend.sync.class.php';
			$this->_service ['DefendSyncService'] = new CloudWind_Defend_Sync ();
		}
		return $this->_service ['DefendSyncService'];
	}
	
	function getSearchAggregateService() {
		if (! $this->_service ['SearchAggregateService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/search.aggregate.class.php';
			$this->_service ['SearchAggregateService'] = new CloudWind_Platform_Aggregate ();
		}
		return $this->_service ['SearchAggregateService'];
	}
	
	function getPlatformTableService() {
		if (! $this->_service ['PlatformTableService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/platform.table.class.php';
			$this->_service ['PlatformTableService'] = new CloudWind_Platform_Table ();
		}
		return $this->_service ['PlatformTableService'];
	}
	
	function getPlatformResetService() {
		if (! $this->_service ['PlatformResetService']) {
			require_once CLOUDWIND_VERSION_DIR . '/service/platform.reset.class.php';
			$this->_service ['PlatformResetService'] = new CloudWind_Platform_Reset ();
		}
		return $this->_service ['PlatformResetService'];
	}
}