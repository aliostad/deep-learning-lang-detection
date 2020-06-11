RPX = {}

RPX[:embed] = true

if true
  RPX[:api_host] = 'rpxnow.com'
  RPX[:api_scheme] = 'https'
  RPX[:api_port] = 443
  RPX[:realm] = 'rrt'
  RPX[:app_id] = 'bfobckokbkbkcmnpindg'
  RPX[:api_key] = 'cf537abdd6cd066910c9afef71befc3f11c0ea23'
  RPX[:js_host] = 'rpxnow.com'
  RPX[:js_port] = nil

else
  RPX[:api_host] = 'oleg.janrain.com'
  RPX[:api_scheme] = 'http'
  RPX[:api_port] = 8080
  RPX[:realm] = 'rrt'
  RPX[:app_id] = 'fmcmdepehoodohnndbng'
  RPX[:api_key] = '95c57546d2e151d148ba699b9c1b94381de3924f'
  RPX[:js_host] = 'oleg.janrain.com'
  RPX[:js_port] = 8080
end

RPX[:signin_url] = "#{RPX[:api_scheme]}://#{RPX[:realm]}.#{RPX[:api_host]}" +
  (RPX[:api_port].blank? ? '' : ":#{RPX[:api_port]}") + '/openid/v2/signin'
RPX[:embed_url] = "#{RPX[:api_scheme]}://#{RPX[:realm]}.#{RPX[:api_host]}" +
  (RPX[:api_port].blank? ? '' : ":#{RPX[:api_port]}") + '/openid/embed'
RPX[:api_url] = "#{RPX[:api_scheme]}://#{RPX[:api_host]}" +
  (RPX[:api_port].blank? ? '' : ":#{RPX[:api_port]}")
RPX[:api_url_v2] = RPX[:api_url] + '/api/v2/'
RPX[:api_url_v3] = RPX[:api_url] + '/api/v3/'
RPX[:api_url_partner] = RPX[:api_url] + '/partner/v2/app/'
RPX[:js_host_port] = RPX[:js_host] +
  (RPX[:js_port].blank? ? '' : ":#{RPX[:js_port]}")

RPX[:api] = {
  :auth_info => RPX[:api_url_v2] + 'auth_info',
  :auth_infos => RPX[:api_url_v2] + 'auth_infos',
  :get_user_data => RPX[:api_url_v2] + 'get_user_data',
  :get_contacts => RPX[:api_url_v2] + 'get_contacts',
  :set_status => RPX[:api_url_v2] + 'set_status',
  :facebook_stream_publish => RPX[:api_url_v2] + 'facebook/stream.publish',
  :activity => RPX[:api_url_v2] + 'activity',
  :map => RPX[:api_url_v2] + 'map',
  :unmap => RPX[:api_url_v2] + 'unmap',
  :facebook_unlink => RPX[:api_url_v3] + 'app/facebook_unlink',
  :facebook_set_app_properties => RPX[:api_url_v3] + 'app/facebook_set_app_properties',
  :clone => RPX[:api_url_partner] + 'clone',
  :set_properties => RPX[:api_url_partner] + 'set_properties',
}
