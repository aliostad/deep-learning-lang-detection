<?php
defined('BASEPATH') OR exit('No direct script access allowed');
  ## API Route
  $route['api-register-customer']['post'] = 'api/CustomerApiCtrl/callReister';
  $route['api-check-username']['post'] = 'api/CustomerApiCtrl/callback_username';
  $route['api-check-invite']['post'] = 'api/CustomerApiCtrl/callback_Invite';

  $route['api-login-customer']['post'] = 'api/CustomerApiCtrl/callLogin';
  
  
  ## API Package
  
  $route['api-get-year-package']['post'] = 'ctrlPackageAPI/YearApiCtrl/callGetService';
  $route['api-save-year-package']['post'] = 'ctrlPackageAPI/YearApiCtrl/callSaveService';
  $route['api-edit-year-package']['post'] = '';
  $route['api-delete-year-package']['post'] = '';
  
  $route['api-get-brand-package']['post'] = 'ctrlPackageAPI/BrandApiCtrl/callGetService';
  $route['api-save-brand-package']['post'] = 'ctrlPackageAPI/BrandApiCtrl/callSaveService';
  $route['api-edit-brand-package']['post'] = '';
  $route['api-delete-brand-package']['post'] = '';
  
  $route['api-get-series-package']['post'] = 'ctrlPackageAPI/SeriesApiCtrl/callGetService';
  $route['api-save-series-package']['post'] = 'ctrlPackageAPI/SeriesApiCtrl/callSaveService';
  $route['api-edit-series-package']['post'] = '';
  $route['api-delete-series-package']['post'] = '';
  
  $route['api-get-main-package']['post'] = 'ctrlPackageAPI/MainApiCtrl/callGetService';
  $route['api-save-main-package']['post'] = 'ctrlPackageAPI/MainApiCtrl/callSaveService';
  $route['api-edit-main-package']['post'] = '';
  $route['api-delete-main-package']['post'] = '';
  
  
  $route['api-get-level-package']['post'] = 'ctrlPackageAPI/LevelApiCtrl/callGetService';
  $route['api-save-level-package']['post'] = 'ctrlPackageAPI/LevelApiCtrl/callSaveService';
  $route['api-edit-level-package']['post'] = '';
  $route['api-delete-level-package']['post'] = '';
  
  
  
  // Slide
  $route['api-get-slide']['post'] = 'SildeApiCtrl/callGetService';
  $route['api-get-content']['post'] = 'ContentCtrl/getContent';
  $route['api-get-content-list']['post'] = 'ContentCtrl/getContentList';

  // Province
  // $route['api-get-province']['get'] = 'ProvinceCtrl/getProvince';
  // $route['api-get-amphoe/(:num)']['get'] = 'ProvinceCtrl/getAmphoe/$1';
  // $route['api-get-district/(:num)/(:num)']['get'] = 'ProvinceCtrl/getDistrict/$1/$2';
  // $route['api-get-zipcode/(:num)']['get'] = 'ProvinceCtrl/getZipcode/$1';
  $route['api-get-province']['post'] = 'ProvinceCtrl/getProvince';
  $route['api-get-amphur']['post'] = 'ProvinceCtrl/getAmphoe';
  $route['api-get-district']['post'] = 'ProvinceCtrl/getDistrict';
  $route['api-get-zipcode']['post'] = 'ProvinceCtrl/getZipcode';
  
  
  $route['api-get-profile']['post'] = 'api/CustomerApiCtrl/getProfile';



  // Popup
  $route['api-get-popup']['post'] = 'api/PopupApiCtrl/getPopup';





