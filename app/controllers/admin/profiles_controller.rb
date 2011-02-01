class Admin::ProfilesController < Admin::BaseController

  def edit
    @editor = current_editor
  end

  def update
    @editor = current_editor

    if @editor.update_attributes(params[:editor])
      redirect_to edit_admin_profile_path, :notice => "Profile was successfully updated."
    else
      render 'edit'
    end
  end
end
