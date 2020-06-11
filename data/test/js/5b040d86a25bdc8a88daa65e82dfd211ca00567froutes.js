//TODO: configure routes and change to api/
module.exports.routes = {
  '/': {
    view: 'static/index'
  },
  '/apikey':{
    view:'static/api'
  },
  '/user/new':{
    controller: 'UserController',
    action: 'new'
  },
  'get /cafeinfo':{
    controller:'CafeinfoController',
    action:'show'
},
  'get /cafeinfo/:id':{
    controller: 'CafeinfoController',
    action: 'showOne'
  },
  'post /cafeinfo':{
    controller:'CafeinfoController',
    action:'create'
  },
  'put /cafeinfo':{
    controller:'CafeinfoController',
    action:'create'
  },
  'delete /cafeinfo/:id':{
    controller: 'CafeinfoController',
    action:'destroy'
  }
};
