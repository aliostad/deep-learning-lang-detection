<?php
$ClassName = 'ShowTimeMaster';
if(!defined("CLASS_$ClassName"))
{
	define("CLASS_$ClassName",true);
	class ShowTimeMaster implements IMaster
	{
		const c_Module_Name = 'ShowTime'; //模块名

		const c_Action_Type_ShowTimeList     = 'ShowTimeList';            //时间列表
		const c_Action_Type_ShowTimeDisplay  = 'ShowTimeDisplay';         //时间显示
		const c_Action_Type_ShowTimeCreate   = 'ShowTimeCreate';          //新建时间
		const c_Action_Type_ShowTimeUpdate   = 'ShowTimeUpdate';          //修改时间
		const c_Action_Type_ShowTimeDelete   = 'ShowTimeDelete';          //删除时间
		const c_Action_Type_ShowTimeMgr      = 'ShowTimeMgr';             //管理时间
		const c_Action_Type_ShowTimeDraw     = 'Draw';                    //绘画时间
		const c_Action_Type_ShowTimeImport   = 'Import';                  //导入时间

		public function getModuleName()
		{
			return self::c_Module_Name;
		}
		
		public function getAction($actionType = null)
		{
			if(is_null($actionType))
			{
				$actionType = CommonAdapter::getRequest('at');
			}

            $moduleName = self::c_Module_Name;
			$folderName = 'Classes/Actions';
			$action = null;
			if($actionType==null) $actionType == self::c_Action_Type_ShowTimeDisplay;

			if($actionType==self::c_Action_Type_ShowTimeDisplay)
			{
				Loader::loadClass('ShowTimeAction_ShowTimeDisplay.class.php',$moduleName,$folderName);
				$action = new ShowTimeAction_ShowTimeDisplay();
			}
			else if($actionType==self::c_Action_Type_ShowTimeDraw)
			{
				Loader::loadClass('ShowTimeAction_ShowTimeDraw.class.php',$moduleName,$folderName);
				$action = new ShowTimeAction_ShowTimeDraw();
			}
			else if($actionType==self::c_Action_Type_ShowTimeList)
			{
				Loader::loadClass('ShowTimeAction_ShowTimeList.class.php',$moduleName,$folderName);
				$action = new ShowTimeAction_ShowTimeList();
			}
			else if($actionType==self::c_Action_Type_ShowTimeCreate)
			{
				Loader::loadClass('ShowTimeAction_ShowTimeCreate.class.php',$moduleName,$folderName);
				$action = new ShowTimeAction_ShowTimeCreate();
			}
			else if($actionType==self::c_Action_Type_ShowTimeMgr)
			{
				Loader::loadClass('ShowTimeAction_ShowTimeMgr.class.php',$moduleName,$folderName);
				$action = new ShowTimeAction_ShowTimeMgr();
			}
			else if($actionType==self::c_Action_Type_ShowTimeUpdate)
			{
				Loader::loadClass('ShowTimeAction_ShowTimeUpdate.class.php',$moduleName,$folderName);
				$action = new ShowTimeAction_ShowTimeUpdate();
			}
			else if($actionType==self::c_Action_Type_ShowTimeDelete)
			{
				Loader::loadClass('ShowTimeAction_ShowTimeDelete.class.php',$moduleName,$folderName);
				$action = new ShowTimeAction_ShowTimeDelete();
			}
			else if($actionType==self::c_Action_Type_ShowTimeImport)
			{
				Loader::loadClass('ShowTimeAction_ShowTimeImport.class.php',$moduleName,$folderName);
				$action = new ShowTimeAction_ShowTimeImport();
			}
			return  $action;
		}
	}
}
?>