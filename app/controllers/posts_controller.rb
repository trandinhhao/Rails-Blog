class PostsController < ApplicationController
  def index
    if params[:user_id] # /users/:user_id/posts
      @user = User.find(params[:user_id])
      if params[:user_id].to_i == Current.user.id # prv + pub
        @posts ||= @user.posts
      else # only pub
        @posts ||= @user.posts.where(visibility: 0)
      end
    end
  end
  def show
    if params[:user_id] # /users/:user_id/posts/:id
      @user = User.find(params[:user_id])
      @post = Post.find_by(user_id: params[:user_id], id: params[:id])
      @comments = Comment.where(post_id: params[:id])
    end
  end

  def new
    if params[:user_id].to_i == Current.user.id
      @post = Post.new
    end
  end

  def create
    if params[:user_id]
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
      @post = Post.find_by(user_id: params[:user_id], id: params[:id])
    end
  end

  def update
    if params[:user_id].to_i == Current.user.id
      @post = Post.find_by(user_id: params[:user_id], id: params[:id])
      @post.update(params.require(:post).permit(:title, :content, :visibility))
      redirect_to user_post_path(params[:user_id], @post), notice: "Update thanh cong"
    end
  end

  def destroy
    if params[:user_id].to_i == Current.user.id
      @post = Post.find_by(user_id: params[:user_id], id: params[:id])
      @post.destroy
      redirect_to user_posts_path(params[:user_id]), notice: "Xoa thanh cong"
    end
  end

end
