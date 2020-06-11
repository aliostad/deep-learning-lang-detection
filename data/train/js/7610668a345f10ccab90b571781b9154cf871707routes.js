module.exports.routes = {

  /* TODO MAIN */
  '/': {
    controller: 'PromoController',
    action: 'promo'
  },
  '/panel':  {
    controller: 'PromoController',
    action: 'index'
  },

  /* TODO SETTINGS */
  '/settings': {
    controller: 'SettingsController',
    action: 'index'
  },
  '/get/vin': {
    controller: 'SettingsController',
    action: 'getVin'
  },
  '/get/makes/': {
    controller: 'SettingsController',
    action: 'getMakes'
  },
  '/get/models/:make/:year': {
    controller: 'SettingsController',
    action: 'getModels'
  },
  '/get/info/models/:type/:id/:year': {
    controller: 'SettingsController',
    action: 'getInfoModels'
  },
  '/set/param': {
    controller: 'SettingsController',
    action: 'setParam'
  },

  /* TODO USER */
  '/user/new':{
    controller: 'UserController',
    action: 'new'
  },
  '/user/login':{
    controller: 'UserController',
    action: 'login'
  },

  /* TODO REQUEST */
  '/request/my':{
    controller: 'RequestController',
    action: 'getRequest'
  },
  '/request/new':{
    controller: 'RequestController',
    action: 'newRequest'
  },

  /* TODO FILE */
  '/upload':{
    controller: 'UploadController',
    action: 'upload'
  },
  '/upload/file':{
    controller: 'UploadController',
    action: 'uploadFile'
  },
  '/upload/delete/:id':{
    controller: 'UploadController',
    action: 'delete'
  },
  '/login': {
    controller: 'AuthController',
    action: 'login'
  },
  '/process': {
    controller: 'AuthController',
    action: 'process'
  },
  '/logout': {
    controller: 'AuthController',
    action: 'logout'
  }

};
