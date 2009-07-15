class Admin::PostsController < ApplicationController

  before_filter :authenticate
  layout "admin"

  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 5, :include => :tags, :order => 'created_at DESC')
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find params[:id]
  end

  def edit
    @post = Post.find params[:id]
  end

  def create
    @post = Post.new(params[:post])

    if @post.save
      flash[:notice] = 'Post was created successfully'
      redirect_to [:admin, @post]
    else
      render :action => :new
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was updated successfully'
      redirect_to [:admin, @post]
    else
      render :action => :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = 'Post was deleted successfully'
    redirect_to admin_posts_url
  end

  def delete
    @post = Post.find(params[:id])
  end
end