class ApiAccessController < ApplicationController
  include ApplicationHelper

  def main_page
    api = ApiMethods.new
    @common = api.getCommon(session)
    @access = api.getAccess(session)
    @data_server = api.getDataServer(session)
    @time = api.getTime(session)
    @holiday = api.getHoliday(session)
    @security = api.getSecurity(session)
    @symbol_group = api.getSymbolGroup(session)
    @symbol = api.getSymbol(session)
    @sym = api.symbolWithEmptySessions
    @backup = api.getBackup(session)
    @group = api.getGroup(session)
    @grp = {}
    @manager = api.getManager(session)
    @mgr = { "secgroups"=> {} }
    @feeder = api.getFeeder(session)
    @fdr = {}
    @synchronization = api.getSynchronization(session)
    @sync = {}
    @plugin = api.getPlugin(session)
    @plg = {"plugin" => {}, "params" => []}
    @account = api.getAccount(session)
    @act = {}
    @order = api.getOrder(session)
    @ord = { "conv_rates" => [] }
  end

  def ping_session
    api = ApiMethods.new
    api.ping(session)
    render :nothing => true
  end

end