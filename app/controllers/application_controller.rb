class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def log_access
    @access_log = AccessLog.create({
      header_json: get_header_vars.to_json,
      session_json: session.to_json,
      controller: params['controller'],
      action: params['action'],
      params: (params.reject {|p| ['action','controller'].include?(p) }).to_json
    })
  end

  private
  def get_header_vars
    hash = {}
    keepers = ['CONTENT_LENGTH', 'CONTENT_TYPE', 'GATEWAY_INTERFACE', 'PATH_INFO', 'QUERY_STRING', 'REMOTE_ADDR', 'REMOTE_HOST', 'REQUEST_METHOD',
      'REQUEST_URI', 'SCRIPT_NAME', 'SERVER_NAME', 'SERVER_PORT', 'SERVER_PROTOCOL', 'SERVER_SOFTWARE', 'HTTP_HOST', 'HTTP_USER_AGENT',
      'HTTP_ACCEPT', 'HTTP_ACCEPT_LANGUAGE', 'HTTP_ACCEPT_ENCODING', 'HTTP_X_CSRF_TOKEN', 'HTTP_X_REQUESTED_WITH', 'HTTP_REFERER',
      'HTTP_COOKIE', 'HTTP_CONNECTION', 'HTTP_PRAGMA', 'HTTP_CACHE_CONTROL', 'HTTP_VERSION', 'REQUEST_PATH', 'ORIGINAL_FULLPATH',
      'ORIGINAL_SCRIPT_NAME']
    headers = request.headers.to_h
    headers_hash = {}
    headers_keys = headers.keys
    keepers.each do |keeper|
      headers_hash[keeper] = headers[keeper] if headers_keys.include?(keeper)
    end
    headers_hash
  end
end

