require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'
require 'cgi'
require 'childprocess'

class Handler  < EventMachine::Connection
  include EventMachine::HttpServer

  def process_http_request
    resp = EventMachine::DelegatedHttpResponse.new( self )

    @http_protocol
    @http_request_method
    @http_cookie
    @http_if_none_match
    @http_content_type
    @http_path_info
    @http_request_uri
    params = CGI.parse(@http_query_string)
    @http_post_content
    @http_headers

    puts "%s: %s" % [Time.new, params] unless params['cmd'][0] == "LCD Update"

    case params['data'][0]
    when "001" # Front Door
      case params['cmd'][0]
      when "Zone Open"
        process = ChildProcess.build('afplay', 'sounds/dooropen.wav'); process.start; process.poll_for_exit(5)
      when "Zone Restored"
        process = ChildProcess.build('afplay', 'sounds/door-1-close.wav'); process.start; process.poll_for_exit(5)
      end
    when "002" # Indoor Livingroom
      case params['cmd'][0]
      when "Zone Open"
        #process = ChildProcess.build('afplay', 'sounds/bleep.wav'); process.start; process.poll_for_exit(5)
      end
    when "003" # Alarm System Tamper
      case params['cmd'][0]
      when "Zone Open"
        process = ChildProcess.build('afplay', 'sounds/alarm.wav'); process.start; process.poll_for_exit(5)
      end
    when "004" # Door Bell
      case params['cmd'][0]
      when "Zone Open"
        (1..5).each do
          process = ChildProcess.build('afplay', 'sounds/doorbell.wav'); process.start; process.poll_for_exit(5)
        end
      end
    when "005" # Movement Outside
      case params['cmd'][0]
      when "Zone Open"
        process = ChildProcess.build('afplay', 'sounds/bleep.wav'); process.start; process.poll_for_exit(5)
      end
    when "031" # Movement Kitchen
      case params['cmd'][0]
      when "Zone Open"
        #process = ChildProcess.build('afplay', 'sounds/bleep.wav'); process.start; process.poll_for_exit(5)
      end
    when "032" # Rear Door
      case params['cmd'][0]
      when "Zone Open"
        process = ChildProcess.build('afplay', 'sounds/dooropen.wav'); process.start; process.poll_for_exit(5)
      when "Zone Restored"
        process = ChildProcess.build('afplay', 'sounds/door-1-close.wav'); process.start; process.poll_for_exit(5)
      end
    end

    resp.status = 200
    resp.content = "OK!\n"
    resp.send_response
  end
end

EventMachine::run {
  EventMachine.epoll
  EventMachine::start_server("0.0.0.0", 8080, Handler)
  puts "Listening..."
}
