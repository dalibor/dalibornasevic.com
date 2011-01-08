class Admin::CommentsController < ApplicationController

  before_filter :authenticate
  layout "admin"

  def index
    conditions = case params[:type]
                 when 'spam'; 'approved = FALSE'
                 when 'not-spam'; 'approved = TRUE'
                 end
    @comments = Comment.paginate(:page => params[:page], :per_page => 10, :conditions => conditions, :include => :post, :order => 'id DESC')
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update_attributes(params[:comment])
      flash[:notice] = 'Comment was updated successfully'
      redirect_to admin_comment_url(@comment)
    else
      render :action => :edit
    end
  end

  def delete
    @comment = Comment.find(params[:id])
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = 'Comment was deleted successfully'
    redirect_to admin_comments_path
  end

  def destroy_multiple
    unless params[:comment_ids].blank?
      Comment.destroy(params[:comment_ids])
      flash[:notice] = "Comments were deleted successfully"
    end
    redirect_to admin_comments_path
  end

  def approve
    @comment = Comment.find(params[:id])
    @comment.mark_as_ham!
    flash[:notice] = 'Comment was approved successfully'
    redirect_to admin_comments_path
  end

  def reject
    @comment = Comment.find(params[:id])
    @comment.mark_as_spam!
    flash[:notice] = 'Comment was rejected successfully'
    redirect_to admin_comments_path
  end
end
