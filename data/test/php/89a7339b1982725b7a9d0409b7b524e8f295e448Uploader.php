<?php

/**
 * 附件上传处理
 * 
 * @author pang
 *
 */

class Msd_Uploader
{
	/**
	 * 保存商家Logo
	 * 
	 */
	public static function SaveVendorLogo($params)
	{
		$config = &Msd_Config::cityConfig();
		$VendorGuid = $params['VendorGuid'];
		$filename = $_FILES[$params['file']]['tmp_name'];
		$result = false;
		
		if ($VendorGuid) {
			$SavePath = $config->attachment->save_path->vendor;
			$storage = &Msd_File_Storage::factory($config->attachment->save->protocol);
			
			try {
				$storage->initDir($SavePath);
				$SavePath .= $VendorGuid.'.jpg';
				
				if ($storage->exists($SavePath)) {
					$storage->rename($SavePath, $SavePath.'.bak');
				}
				
				$storage->save($filename, $SavePath, 'move_uploaded_file');
				
				if ($storage->exists($SavePath.'.bak')) {
					$storage->del($SavePath.'.bak');
				}
				
				$result = true;
			} catch (Exception $e) {
				Msd_Log::getInstance()->uploader($e->getTraceAsString()."\n".$e->getMessage());
			}
		}
		
		return $result;
	}
	
	/**
	 * 保存商家Logo(大）
	 * 
	 */
	public static function SaveVendorLogoBig($params)
	{
		$config = &Msd_Config::cityConfig();
		$VendorGuid = $params['VendorGuid'];
		$filename = $_FILES[$params['file']]['tmp_name'];
		$result = false;
		
		if ($VendorGuid) {
			$SavePath = $config->attachment->save_path->vendor_big;
			$storage = &Msd_File_Storage::factory($config->attachment->save->protocol);
			
			try {
				$storage->initDir($SavePath);
				
				$SavePath .= $VendorGuid.'.jpg';
				
				if ($storage->exists($SavePath)) {
					$storage->rename($SavePath, $SavePath.'.bak');
				}
				
				$storage->save($filename, $SavePath, 'move_uploaded_file');
				
				if ($storage->exists($SavePath.'.bak')) {
					$storage->del($SavePath.'.bak');
				}
				
				$result = true;
			} catch (Exception $e) {
				Msd_Log::getInstance()->uploader($e->getTraceAsString()."\n".$e->getMessage());
			}
		}
		
		return $result;
	}
	
	/**
	 * 保存菜品图片
	 * 
	 */
	public static function SaveItemImage($params)
	{
		$config = &Msd_Config::cityConfig();
		$ItemGuid = $params['ItemGuid'];
		$VendorGuid = $params['VendorGuid'];
		$filename = $_FILES[$params['file']]['tmp_name'];
		$result = false;
		
		if ($ItemGuid && $VendorGuid) {
			$SavePath = $config->attachment->save_path->items;
			$SavePath .= $VendorGuid;

			$storage = &Msd_File_Storage::factory($config->attachment->save->protocol);
			try {
				$storage->initDir($SavePath);
				
				$SavePath .= '/' . $ItemGuid.'.jpg';
				
				if ($storage->exists($SavePath)) {
					$storage->rename($SavePath, $SavePath.'.bak');
				}
				
				$storage->save($filename, $SavePath, 'move_uploaded_file');
				
				if ($storage->exists($SavePath.'.bak')) {
					$storage->del($SavePath.'.bak');
				}
				
				Msd_Cache_Remote::getInstance()->set('iurl_'.$ItemGuid);
				
				$result = true;
			} catch (Exception $e) {
				Msd_Log::getInstance()->uploader($e->getTraceAsString()."\n".$e->getMessage());
			}
		}
		
		return $result;
	}
	
	/**
	 * 保存菜品（首页推荐）图片
	 * 
	 */
	public static function SaveItemBigImage($params)
	{
		$config = &Msd_Config::cityConfig();
		$ItemGuid = $params['ItemGuid'];
		$VendorGuid = $params['VendorGuid'];
		$filename = $_FILES[$params['file']]['tmp_name'];
		$result = false;
		
		if ($ItemGuid && $VendorGuid) {
			$SavePath = $config->attachment->save_path->items_big;
			$SavePath .= $VendorGuid;

			$storage = &Msd_File_Storage::factory($config->attachment->save->protocol);
			try {
				$storage->initDir($SavePath);
				
				$SavePath .= '/' . $ItemGuid.'.jpg';

				if ($storage->exists($SavePath)) {
					$storage->rename($SavePath, $SavePath.'.bak');
				}
				
				$storage->save($filename, $SavePath, 'move_uploaded_file');
				
				if ($storage->exists($SavePath.'.bak')) {
					$storage->del($SavePath.'.bak');
				}
				
				Msd_Cache_Remote::getInstance()->set('iburl_'.$ItemGuid);
				
				$result = true;
			} catch (Exception $e) {
				Msd_Log::getInstance()->uploader($e->getTraceAsString()."\n".$e->getMessage());
			}
		}
		
		return $result;
	}
	//保存我要上封面活动用户头像
	public static function saveHeadPhotoImage()
	{
		$myfilename = $_FILES['myfile']['name'];
		$arr = explode('.',$myfilename);
		
		$config = &Msd_Config::cityConfig();
		$filename = $_FILES['myfile']['tmp_name'];
		
		$SavePath = '/p/www/images.fandian.com/images/head_photo/';
		
		try {
			$storage = &Msd_File_Storage::factory($config->attachment->save->protocol);
			$storage->initDir('/p/www/images.fandian.com/images/head_photo/');
			$newfilename = time().rand(0, 9).'.'.$arr[1];
			$SavePath .= $newfilename;
			if($storage->save($filename, $SavePath, 'move_uploaded_file',$newfilename))
			{
				$result = $newfilename;
			}else
			{
				$result = 0;
			}
			
		}catch (Exception $e) {
			Msd_Log::getInstance()->uploader($e->getTraceAsString()."\n".$e->getMessage());
			$result = 0;
		}
		return $result;
		
	}
	public static function SaveItemSpecialImage($params)
	{
		$config = &Msd_Config::cityConfig();
		$ItemGuid = $params['ItemGuid'];
		$VendorGuid = $params['VendorGuid'];
		$filename = $_FILES[$params['file']]['tmp_name'];
		$result = false;
	
		if ($ItemGuid && $VendorGuid) {
			$SavePath = $config->attachment->save_path->items_special;
			$SavePath .= $VendorGuid;
	
			$storage = &Msd_File_Storage::factory($config->attachment->save->protocol);
			try {
				$storage->initDir($SavePath);
	
				$SavePath .= '/' . $ItemGuid.'.jpg';
	
				if ($storage->exists($SavePath)) {
					$storage->rename($SavePath, $SavePath.'.bak');
				}
	
				$storage->save($filename, $SavePath, 'move_uploaded_file');
	
				if ($storage->exists($SavePath.'.bak')) {
					$storage->del($SavePath.'.bak');
				}
	
				Msd_Cache_Remote::getInstance()->set('isurl_'.$ItemGuid);
	
				$result = true;
			} catch (Exception $e) {
				Msd_Log::getInstance()->uploader($e->getTraceAsString()."\n".$e->getMessage());
			}
		}
	
		return $result;
	}
	
	/**
	 * 排序hash中的文件
	 * 
	 * @param unknown_type $hashOrders
	 */
	public static function SaveFilesOrder($hashOrders)
	{
		$arr = explode(',', $hashOrders);
		$arr || $arr = array();
		$i = 1000;
		$dao = &Msd_Dao::table('attachment');
		
		foreach ($arr as $fid) {
			if ($fid) {
				$dao->doUpdate(array(
						'OrderNo' => $i
						), $fid);
				$i += 10;
			}
		}		
	}
	
	/**
	 * 保存附件信息到数据库、服务器
	 * 
	 * @param array $params
	 */
	public static function Save(array $params)
	{
		$file = &$params['file'];
		$hash = &$params['hash'];
		$usage = isset($params['usage']) ? $params['usage'] : 'article';
		
		$f = $_FILES[$file];
		$fid = sha1(uniqid(mt_rand()));
		$ext = substr(strrchr($f['name'], '.'), 1);
		
		$width = $height = 0;
		if (preg_match('/image/i', $f['type'])) {
			list($width, $height) = getimagesize($f['tmp_name']);
		}
		
		$config = &Msd_Config::cityConfig()->toArray();
		
		$s = array();
		$s['FileId'] = $fid;
		$s['Name'] = $f['name'];
		$s['MimeType'] = $f['type'];
		$s['Size'] = $f['size'];
		$s['Uid'] = Msd_Session::getInstance()->get('uid');
		$s['Hash'] = $hash;
		$s['Description'] = '';
		$s['Ext'] = substr(strrchr($f['name'], '.'), 1);
		$s['Usage'] = (int)$config['attachment']['usage'][$usage];
		$s['Width'] = $width;
		$s['Height'] = $height;
		$s['CityId'] = $config['city_id'];

		Msd_Dao::table('attachment')->insert($s);
		
		$storage = &Msd_File_Storage::factory($config['attachment']['save']['protocol']);

		$SavePath = $config['attachment']['save_path'][$usage];
		$storage->initDir($SavePath);
		$SavePath .= substr($fid, 0, 1).'/';
		$storage->initDir($SavePath);
		$SavePath .= substr($fid, 1, 1).'/';
		$storage->initDir($SavePath);
		
		$storage->save($f['tmp_name'], $SavePath.$fid.'.'.$s['Ext'], 'move_uploaded_file');
	
		$r = $f;
		$r['file_id'] = $fid;
		$r['ext'] = $s['Ext'];
		$r['err'] = '';
	
		return $r;
	}
	
	/**
	 * 删除附件
	 * 
	 * @param unknown_type $fid
	 */
	public static function Del($fid)
	{
		$config = &Msd_Config::cityConfig();
		
		$SavePath = $config->attachment->save_path->article.'/'.substr($fid, 0, 1).'/'.substr($fid, 1, 1).'/'.$fid.'.jpg';
		$storage = &Msd_File_Storage::factory($config->attachment->save->protocol);
		$storage->del($SavePath);
		
		Msd_Dao::table('attachment')->doDelete($fid);
		Msd_Dao::table('attachment/data')->doDelete($fid);
	}
}