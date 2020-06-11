class Api::ScriptController < ApplicationController
  before_filter -> { validate_rights 'manage_jobs' }, only: [:create]

  def show
    process_id = params[:id]
    @response[:script] = ScriptManager.process_status(process_id: process_id)
    render_json
  end
  
  def create
    if !params[:script]
      error_msg(ErrorCodes::REQUEST_ERROR, "Unable to run process #{params[:process_name]}")
    else
      process_name = params[:script][:process_name]
      script_params = params[:script][:params]
      errors = ScriptManager.param_error_check(process_name: process_name,
                                             params: script_params)
      if errors.present?
        error_msg(ErrorCodes::VALIDATION_ERROR, "Could not start process #{process_name}", errors)
        render_json
        return
      end
      process_id = ScriptManager.run(process_name: process_name,
                                     params: script_params)
      
      
      if !process_id
        error_msg(ErrorCodes::REQUEST_ERROR, "Unable to run process #{params[:process_name]}")
      else
        @response[:script] = {
          id: process_id
        }
      end
    end
    
    render_json
  end
end
