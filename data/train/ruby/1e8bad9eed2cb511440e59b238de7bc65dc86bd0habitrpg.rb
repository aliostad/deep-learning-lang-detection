require "habitrpg/version"
require "habitrpg/tasks"
require "habitrpg/groups"

require "rest-client"

class HabitRPG_API
  include Tasks
  include Groups

  def initialize(api_user, api_token)
    @api_user = api_user
    @api_token = api_token
  end

  def delete(url, params = nil)
    JSON.parse(RestClient.delete("https://habitrpg.com/api/v2/#{url}", { 'x-api-key' => @api_token, 'x-api-user' => @api_user }))
  end

  def post(url, params = nil)
    JSON.parse(RestClient.put("https://habitrpg.com/api/v2/#{url}", params, { 'x-api-key' => @api_token, 'x-api-user' => @api_user }))
  end

  def post(url, params = nil)
    JSON.parse(RestClient.post("https://habitrpg.com/api/v2/#{url}", params, { 'x-api-key' => @api_token, 'x-api-user' => @api_user }))
  end

  def get(url, params = nil)
    JSON.parse(RestClient.get("https://habitrpg.com/api/v2/#{url}", { 'x-api-key' => @api_token, 'x-api-user' => @api_user }))
  end
end
