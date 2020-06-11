module.exports = {
  route: {
    directory: '',
    controller: 'home',
    action: 'index',
    arguments: []
  },

  routes: [
    ['get api/:resource',          'api/index'],
    ['get api/:resource/new',      'api/new'],
    ['post api/:resource',         'api/create'],
    ['get api/:resource/:id',      'api/get'],
    ['get api/:resource/:id/edit', 'api/edit'],
    ['put api/:resource/:id',      'api/update'],
    ['delete api/:resource/:id',   'api/remove'],
    ['post api/:resource/:method', 'api/action'],

    [':page', 'home/index']
  ],

  controller_404: 'home',
  action_404: '_404',
  
  allowed_characters: '-_:~%.\/a-zа-я0-9'
}
