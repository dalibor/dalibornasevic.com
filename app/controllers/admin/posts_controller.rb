class Admin::PostsController < Admin::BaseController

  inherit_resources

  def index
    # TODO: move to model
    @posts = Post.paginate(:page => params[:page], :per_page => 15,
                           :select => "id, title, published_at",
                           :include => :tags,
                           :order => 'id DESC')
  end

end
