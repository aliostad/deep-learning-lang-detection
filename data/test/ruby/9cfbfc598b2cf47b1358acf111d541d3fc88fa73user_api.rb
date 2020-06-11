#########################################################
# Xavier Demompion : xavier.demompion@mobile-devices.fr
# Mobile Devices 2013
#########################################################

require_relative 'com/user_api_included'

class UserApiClass < Struct.new(:initial_event_content)

  def initialize(user_class, env, md5env)
    @USER_CLASS = user_class
    @USER_AGENT_CLASS_ENV = env
    @USER_AGENT_CLASS_ENV_MD5 = md5env

    CC.logger.debug("creating new user api of #{@USER_CLASS} with env #{env} with md5api='md5env'")
  end

  def user_class
    @USER_CLASS
  end

  def user_environment
    @USER_AGENT_CLASS_ENV
  end

  def user_environment_md5
    @USER_AGENT_CLASS_ENV_MD5
  end

  def account
    @ACCOUNT ||= user_environment['account']
  end

  def account=(account)
    @ACCOUNT = account
  end

  def agent_name
    @AGENT_NAME ||= user_environment['agent_name']
  end

  def running_env_name
    @RUNNING_ENV_NAME ||= user_environment['running_env_name']
  end

  include UserApiIncluded

end


$user_api_mutex = Mutex.new
$user_api_mutex.unlock if $user_api_mutex.locked?

# constant api chaned on each message
def set_current_user_api(api)
  $user_api_mutex.lock
  CC.logger.debug("API: set current api to #{api == nil ? 'nil' : api.user_environment}")
  $SDK_API = api
end

def release_current_user_api
  CC.logger.debug("API: release_current_api #{user_api}")
  $user_api_mutex.unlock if $user_api_mutex.locked?
end

# used in case of no user_api is found
def user_api
  if $SDK_API == nil
    CC.logger.warn("API: using fallback user_api nil")
    env = {
      'account' => 'none',
      'agent_name' => 'nil'
    }
    $NIL_API ||= UserApiClass.new(nil, env, '007')
  else
    CC.logger.debug("API: using user_api #{$SDK_API.user_environment}")
    $SDK_API
  end
end
