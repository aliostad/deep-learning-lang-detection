# encoding: utf-8
require "gdeposylka_api/version"
require "gdeposylka_api/base"
require "gdeposylka_api/parcel"

require "gdeposylka_api/railtie"  if defined?(::Rails)

module GdeposylkaApi

  extend self

  HOST        = 'ws.gdeposylka.ru'
  TIMEOUT     = 30
  PORT        = 80
  RETRY       = 3
  WAIT_TIME   = 5
  USE_SSL     = false
  API_VERSION = 'x1'

  def api_key(key = nil)

    @api_key = key unless key.nil?
    @api_key

  end # api_key

  def tracks
    @tracks ||= ::GdeposylkaApi::Base.new(self.api_key)
  end # tracks

  def debug_on

    @debug = true
    puts "[GdeposylkaApi] Отладочный режим ВКЛЮЧЕН"
    self

  end # debug_on

  def debug_off

    @debug = false
    puts "[GdeposylkaApi] Отладочный режим ОТКЛЮЧЕН"
    self

  end # debug_off

  def debug?
    @debug === true
  end # debug?

end # GdeposylkaApi
