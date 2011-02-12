class Admin::PostsController < Admin::BaseController

  inherit_resources

  def index
    @posts = current_editor.posts.order('created_at DESC').
      paginate(:page => params[:page], :per_page => 15)
  end

  protected

    def begin_of_association_chain
      current_editor
    end
end
