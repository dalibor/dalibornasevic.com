class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_editor

  private

    def authenticate
      redirect_to root_path, :error => "Access denied." unless current_editor
    end

    def current_editor
      @current_editor ||= Editor.find(session[:editor_id]) if session[:editor_id]
    end
end
