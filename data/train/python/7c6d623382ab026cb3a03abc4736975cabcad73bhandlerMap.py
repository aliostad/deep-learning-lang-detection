from lib.routes.route import Route
webapphandlers=(
      Route('home', '/', controller="cms/cmslinks", action="index", menu='pages'),
      Route('login', '/login.html', controller="base/login", action="login"),
      Route('logout', '/logout.html', controller="base/login", action="logout"),
      Route('register', '/register.html', controller="base/login", action="register"),
      Route('r', '/{controller}/{action}.html'),
      Route('r_with_id', '/{controller}/{id}/{action}'),
      Route('r_default', '/{controller}', action='index'),
      Route('r_default_with_id', '/{controller}/{id}'),
)