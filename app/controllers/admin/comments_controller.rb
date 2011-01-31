class Admin::CommentsController < Admin::BaseController

  inherit_resources

  def index
    conditions = case params[:type]
                 when 'spam'; 'approved = FALSE'
                 when 'not-spam'; 'approved = TRUE'
                 end
    @comments = Comment.paginate(:page => params[:page], :per_page => 10, :conditions => conditions, :include => :post, :order => 'id DESC')
  end

  def destroy_multiple
    unless params[:comment_ids].blank?
      Comment.destroy(params[:comment_ids])
      flash[:notice] = "Comments were successfully destroyed."
    end
    redirect_to admin_comments_path
  end

  def approve
    @comment = Comment.find(params[:id])
    @comment.mark_as_ham!
    flash[:notice] = 'Comment was approved successfully.'
    redirect_to admin_comments_path
  end

  def reject
    @comment = Comment.find(params[:id])
    @comment.mark_as_spam!
    flash[:notice] = 'Comment was rejected successfully.'
    redirect_to admin_comments_path
  end
end
