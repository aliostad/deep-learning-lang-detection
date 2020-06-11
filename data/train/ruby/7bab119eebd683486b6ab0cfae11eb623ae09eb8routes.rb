BasicRuby::Application.routes.draw do
  get '/:topic_num' => 'application#index',
    topic_num: /([0-9]+)([PYBRGO])/

  get '/:topic_num/:rep_num' => 'application#index',
    topic_num: /([0-9]+)([PYBRGO])/, rep_num: /([0-9]+)/

  get  '/api/all_exercises'            => 'api#all_exercises'
  get  '/api/menu'                     => 'api#menu'
  get  '/api/exercise/:path'           => 'api#exercise'
  get  '/api/exercise/:path/:rep_num'  => 'api#exercise'
  post '/api/mark_complete'            => 'api#mark_complete'
end
