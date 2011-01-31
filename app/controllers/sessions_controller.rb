class SessionsController < ApplicationController

  def new
  end

  def create
    editor = Editor.authenticate(params[:email], params[:password])
    if editor
      session[:editor_id] = editor.id
      redirect_to root_url, :notice => 'Logged in!'
    else
      flash.now.alert = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    session[:editor_id] = nil
      redirect_to root_url, :notice => 'Logged out!'
  end
end
