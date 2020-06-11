class ReportsController < ApplicationController
  UDP_SERVER_ACTIONS = [:create]

  skip_before_filter :verify_authenticity_token, only: UDP_SERVER_ACTIONS
  http_basic_authenticate_with name: ENV['UDP_AUTH_USER'],
    password: ENV['UDP_AUTH_PASS'], only: UDP_SERVER_ACTIONS
  before_action :authenticate_user!, except: UDP_SERVER_ACTIONS

  def create
    @report = Report.new(report_params)

    unless Trap.where(id: @report.trap_id).any?
      Trap.create(id: @report.trap_id)
    end

    @report.save

    params.fetch(:chunks, []).each do |chunk_hash|
      report_chunk = ReportChunk.new(chunk_params(chunk_hash).merge(trap_id: @report.trap_id))
      if report_chunk.valid?
        report_chunk.save
      end
    end

    render plain: "OK"
  end

  def index
    @reports = Report.order(created_at: :desc)
  end

  private
  def report_params
   params.require(:report).permit(
     :original_message, :protocol_version, :trap_id, :sent_at)
  end

  def chunk_params(hash)
    ActionController::Parameters.new(chunk: hash).require(:chunk)
      .tap do |whitelisted|
        [:chunk_type, :generated_at, :data].each do |key|
          whitelisted[key] = hash[key]
        end
      end
      .permit!
  end
end
