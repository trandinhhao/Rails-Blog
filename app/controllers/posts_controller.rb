class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update ]
  skip_before_action :verify_authenticity_token
  def index
    @user = User.find(params[:user_id])
    @posts
    if params[:user_id].to_i == Current.user.id # prv + pub
      @posts ||= @user.posts
    else # only pub
      @posts ||= @user.posts.where(visibility: 0)
    end
    render json: @posts, status: :ok
  end
  def show
    # @post = Post.find(params[:id])
    if @post.visibility.to_i == 1 and params[:user_id].to_i != Current.user.id
      render json: { message: "Không thể xem post prv của người khác!" }, status: :unprocessable_entity
    else
      render json: @post, status: :ok
    end
  end

  # def new
  #   if params[:user_id].to_i == Current.user.id
  #     @post = Post.new
  #   else
  #     render json: { message: "Không được phép!" }, status: :unprocessable_entity
  #   end
  # end

  def create
    if params[:user_id].to_i == Current.user.id
      @post = Current.user.posts.build(params.permit(:title, :content, :visibility))
      if @post.save
        render json: { message: "Tao post thanh cong", post: @post}, status: :ok
      else
        render json: { message: "Tạo post thất bại!" }, status: :unprocessable_entity
      end
    else
      render json: { message: "Không được phép tạo post bằng role người khác!" }, status: :unprocessable_entity
    end
  end

  # def edit
  #   if params[:user_id].to_i == Current.user.id
  #     @user = User.find(params[:user_id])
  #   else
  #     render json: { message: "Không được phép!" }, status: :unprocessable_entity
  #   end
  # end

  def update
    if params[:user_id].to_i == Current.user.id
      # @post ||= Post.find(params[:id])
      if @post != nil
        @post.update(params.permit(:title, :content, :visibility))
        render json: { message: "Cap nhat ok", post: @post }, status: :ok
      else
        render json: { message: "Lỗi khi cập nhat!" }, status: :unprocessable_entity
      end
    else
      render json: { message: "Không được phép sửa post bằng role người khác!" }, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id].to_i == Current.user.id
      @post ||= Post.find_by(id: params[:id])
      @post&.destroy
      render json: { message: "Da thuc hien thao tac xoa!" }, status: :unprocessable_entity
    else
      render json: { message: "Không được phép xoá post bằng role người khác!" }, status: :unprocessable_entity
    end
  end

  private
    def set_post
      @post ||= Post.find(params[:id])
    end
end
