class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def authenticate
      authenticate_or_request_with_http_basic(REALM) do |username, password|
        username == USERNAME && password == PASSWORD
      end
    end
end
