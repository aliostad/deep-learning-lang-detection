require "cloud_upload/handler/form_handler"
require "cloud_upload/handler/upload_handler"
require "cloud_upload/handler/status_handler"
require "cloud_upload/handler/not_found_handler"

class CloudUploadApp
  IN_PROGRESS = {}

  def call(env)
    request = Rack::Request.new(env)

    case request.path
    when /\/$/
      return FormHandler.new.handle(request)
    when /\/upload$/
      return UploadHandler.new.handle(request)
    when /\/status$/
      return StatusHandler.new.handle(request)
    else
      return NotFoundHandler.new.handle(request)
    end
  end
end
