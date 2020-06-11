=begin
скрипт рабочий необходимо только поменять параметр api_dev_key (свой я не оставлять)
=end

require 'net/http'
require 'uri'

uri = URI("http://pastebin.com/api/api_post.php")
response = Net::HTTP.post_form(uri, 'api_dev_key' => '086f0d6d4e91d8d7a7b44a0735c04f7d', 'api_option' => 'paste', 'api_paste_code' => 'my paste second text example', 'api_paste_expire_date' => '10M', 'api_paste_private' => '1', 'api_paste_name'=> 'My Paste')
response.body
