class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[ index show edit update destroy create ]

  def index
    if params[:user_id].to_i == Current.user.id # prv + pub
      @posts ||= @user.posts
    else # only pub
      @posts ||= @user.posts.where(visibility: 0)
    end
    @posts
  end
  def show
    if @post.visibility.to_i == 1 and params[:user_id].to_i != Current.user.id
      render json: { message: "Không thể xem post prv của người khác!" }, status: :unprocessable_entity
      return
    end
    @post
    @user
  end

  def new
    if params[:user_id].to_i != Current.user.id
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
      return
    end
    @post = Post.new
  end

  def create
    if params[:user_id].to_i != Current.user.id
      render json: { message: "Không được phép tạo post bằng role người khác!" }, status: :unprocessable_entity
      return
    end

    @post = Current.user.posts.build(params.permit(:title, :content, :visibility))
    if @post.save
      redirect_to user_posts_path(@user), notice: "Tạo post thành công!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if params[:user_id].to_i != Current.user.id
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
      return
    end
    @user
  end

  def update
    if params[:user_id].to_i != Current.user.id
      render json: { message: "Không được phép sửa post bằng role người khác!" }, status: :unprocessable_entity
      return
    end

    if @post != nil
      @post.update(params.permit(:title, :content, :visibility))
      redirect_to user_posts_path(@user), notice: "Cap nhat post thanh cong!"
    else
      render json: { message: "Lỗi khi cập nhat!" }, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id].to_i != Current.user.id
      render json: { message: "Không được phép xoá post bằng role người khác!" }, status: :unprocessable_entity
      return
    end
    @post&.destroy
    redirect_to user_posts_path(@user), notice: "Xoa thanh cong!"
  end

  private
    def set_post
      @post ||= Post.find(params[:id])
    end

    def set_user
      @user ||= User.find(params[:user_id])
    end
end
