class Admin::PostsController < ApplicationController

  before_filter :authenticate

  def index
    @posts = Post.find(:all, :limit => 5, :order => 'created_at DESC')
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
      flash[:notice] = 'New post created.'
      redirect_to [:admin, @post]
    else
      render :action => :new
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated'
      redirect_to [:admin, @post]
    else
      render :action => :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = 'Post was successfully deleted'
    redirect_to admin_posts_path
  end

  def delete
    @post = Post.find(params[:id])
  end
end
