class Admin::BaseController < ApplicationController

  before_filter :authenticate
  layout "admin"

  helper_method :current_editor

  private

    def authenticate
      redirect_to login_url, :error => "Access denied." unless current_editor
    end

    def require_admin
      if current_editor && !current_editor.is_admin?
        session[:editor_id] = nil # clean session
        redirect_to login_url, :alert => "Access denied."
      end
    end

    def current_editor
      @current_editor ||= Editor.find(session[:editor_id]) if session[:editor_id]
    end
end
