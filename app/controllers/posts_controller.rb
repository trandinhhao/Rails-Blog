class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  def index
    @user = User.find(params[:user_id])
    @posts
    if params[:user_id].to_i == Current.user.id # prv + pub
      @posts ||= @user.posts
    else # only pub
      @posts ||= @user.posts.where(visibility: 0)
    end
  end
  def show
    if params[:user_id]
      @user = User.find(params[:user_id])
      #@comments = Comment.where(post_id: params[:id])
    end
  end

  def new
    if params[:user_id].to_i == Current.user.id
      @post = Post.new
    end
  end

  def create
    if params[:user_id].to_i == Current.user.id
      @post = Current.user.posts.build(params.require(:post).permit(:title, :content, :visibility))
      if @post.save
        redirect_to user_posts_path, notice: "Tạo  post thành công!"
      else
        render :new
      end
    else
      redirect_to user_posts_path, notice: "Tạo post thất bại!"
    end
  end

  def edit
    if params[:user_id].to_i == Current.user.id
      @user = User.find(params[:user_id])
    end
  end

  def update
    if params[:user_id].to_i == Current.user.id
      @post = Post.find_by(user_id: params[:user_id], id: params[:id])
      @post.update(params.require(:post).permit(:title, :content, :visibility))
      redirect_to user_post_path(params[:user_id], params[:id])
    end
  end

  def destroy
    if params[:user_id].to_i == Current.user.id
      @post.destroy
      redirect_to user_posts_path(Current.user), notice: "Xoa thanh cong"
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end
end
