class Admin::ApiVisitLogsController < AdminController
  before_action :setup

  set_tab :development
  set_tab :api_visit_logs, :sub_nav

  def index
    params[:api_visit_log] ||= {}
    @api_visit_logs = ApiVisitLog.all
    @api_visit_logs = @api_visit_logs.where(remote_ip: params[:api_visit_log][:remote_ip]) unless params[:api_visit_log][:remote_ip].blank?
    @api_visit_logs = @api_visit_logs.where(client_id: params[:api_visit_log][:client_id]) unless params[:api_visit_log][:client_id].blank?
    @api_visit_logs = @api_visit_logs.where(response_status: params[:api_visit_log][:response_status]) unless params[:api_visit_log][:response_status].blank?
    @api_visit_logs = @api_visit_logs.where(request: params[:api_visit_log][:request]) unless params[:api_visit_log][:request].blank?
    @api_visit_logs = @api_visit_logs.where(warned: params[:api_visit_log][:warned]) unless params[:api_visit_log][:warned].blank?
    @api_visit_logs = @api_visit_logs.where('request_data like ?', "%#{params[:api_visit_log][:request_data]}%") unless params[:api_visit_log][:request_data].blank?
    @api_visit_logs = @api_visit_logs.before_date(params[:api_visit_log][:end_date]) unless params[:api_visit_log][:end_date].blank?
    @api_visit_logs = @api_visit_logs.after_date(params[:api_visit_log][:start_date]) unless params[:api_visit_log][:start_date].blank?
    @api_visit_logs = @api_visit_logs.order('created_at desc').page params[:page]
  end

  private
  def setup
    @left_panel = "admin/exception_logs/left_panel"
  end

end
