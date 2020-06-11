Router.route('/', {
  name: 'home',
  controller: 'HomeController'
});

Router.route('/signUp', {
  name: 'signUp',
  controller: 'SignUpController'
});

Router.route('/signIn', {
  name: 'signIn',
  controller: 'SignInController'
});

Router.route('/coding-group', {
  name: 'coding-group',
  controller: 'CodingGroupController'
});

Router.route('/alumni', {
  name: 'alumni',
  controller: 'AlumniController'
});

Router.route('/photos', {
  name: 'photos',
  controller: 'PhotosController'
});

Router.route('/archive', {
  name: 'archive',
  controller: 'ArchiveController'
});

Router.route('archive/create', {
  name: 'createPost',
  controller: 'CreatePostController'
});

Router.route('/activities', {
  name: 'activities',
  controller: 'ActivitiesController'
});

Router.route('/dashboard', {
  name: 'dashboard',
  controller: 'DashboardController'
});

Router.route('/profile', {
  name: 'profile',
  controller: 'ProfileController'
});
