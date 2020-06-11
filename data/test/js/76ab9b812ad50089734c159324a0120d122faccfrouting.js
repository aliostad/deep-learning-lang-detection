module.exports = {
  methods: ['head', 'options', 'get', 'post', 'put', 'patch', 'delete'],
  cache: false,

  route: {
    directory: '',
    controller: 'home',
    action: 'index',
    arguments: []
  },

  routes: [
    // example RESTfull routes
    // ['options   api',                                     'api/options'],
    // ['options   api/:resource',                           'api/options'],
    // ['options   api/*',                                   'api/options'],

    // ['head      api/:resource',                           'api/head'],
    // ['get       api/:resource',                           'api/get'],
    // ['post      api/:resource',                           'api/create'],
    // ['get       api/:resource/:id([a-z0-9]{24})',         'api/read'],
    // ['put|patch api/:resource/:id([a-z0-9]{24})',         'api/update'],
    // ['delete    api/:resource/:id([a-z0-9]{24})',         'api/delete'],

    // ['get       api/:resource/:id([a-z0-9]{24})/:docs',   'api/populate'],
    // ['post      api/:resource/:action',                   'api/action'],
    // ['post      api/:resource/:id([a-z0-9]{24})/:action', 'api/method'],

    ['*', 'home/:1']
  ],

  _404: {
    controller: 'home',
    action: '_404'
  }
}
