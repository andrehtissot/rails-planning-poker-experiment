class BrowserLogsController < ApplicationController
  before_action :log_access

  def create
    params[:events_jsons].each do |event_json|
      if @access_log.nil? || @access_log.new_record?
        BrowserLog.create({event_json: event_json, header_json: get_header_vars.to_json})
      else
        BrowserLog.create({event_json: event_json, access_log: @access_log})
      end
    end
    render nothing: true
  end
end
