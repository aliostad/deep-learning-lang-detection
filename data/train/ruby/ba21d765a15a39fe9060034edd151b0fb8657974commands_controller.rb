class Api::CommandsController < Api::BaseController

  def process_command
    resource = User.find_for_database_authentication(:email=>params[:user][:email], :authentication_token => params[:user][:auth_token])
    if !resource.nil? && !params[:command].empty?
      command = params[:command]
      if chk_format(command)
        process_result = process_command_task(command.clone)
        if process_result[:process_msg].class.to_s == "Hash"
          command = process_result[:process_msg][:success_status] ? "" : params[:command]
        end
        if process_result[:show_data] && process_result[:task] == 'find'
          search_data = []
          if process_result[:apply_to] == 'insync'
            search_data = process_insync(process_result[:apply_to], process_result[:process_values])
          else
            search_data = process_find(process_result[:apply_to], process_result[:process_values])
          end
          render :json=> {:success=>true, :data => {:search_type => search_data[:search_type], :search_data => search_data[:search_data]}, :message => !search_data[:search_message].nil? ? api_command_message(search_data[:search_message]) : "", :process_result => process_result, :command => command}
        elsif process_result[:task] == 'subscription' || process_result[:task] == 'buzzout'
          render :json=> {:success=>true, :message => api_command_message(process_result[:process_msg][:msg]), :process_result => process_result, :command => command}
        else
          render :json=> {:success=>true, :message => api_command_message(process_result[:process_msg][:msg]), :process_result => process_result, :command => command}
        end
      else
        render :json=> {:success=>false, :message => 'Invalid Command', :status=>401, :process_result => '', :command => command}
      end
    end
  end

end
