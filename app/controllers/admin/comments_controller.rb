class Admin::CommentsController < Admin::BaseController

  inherit_resources

  def index
    conditions = case params[:type]
                 when 'spam'; 'approved = FALSE'
                 when 'not-spam'; 'approved = TRUE'
                 end
    @comments = comments.paginate(:page => params[:page], :per_page => 10, :conditions => conditions, :include => :post, :order => 'id DESC')
  end

  def destroy_multiple
    if params[:comment_ids].present?
      comments.destroy(params[:comment_ids])
      flash[:notice] = "Comments were successfully destroyed."
    end
    redirect_to admin_comments_path
  end

  def approve
    resource.mark_as_ham!
    redirect_to admin_comments_path, :notice => 'Comment was approved successfully.'
  end

  def reject
    resource.mark_as_spam!
    redirect_to admin_comments_path, :notice => 'Comment was rejected successfully.'
  end

  protected

    def resource
      @comment ||= comments.find(params[:id])
    end

    def comments
      @comments ||= Comment.on_posts_of(current_editor)
    end
end
