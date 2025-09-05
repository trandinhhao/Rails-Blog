class PostFollowsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    if params[:user_id].to_i == Current.user.id
      @user = User.find(params[:user_id])
      @posts = @user.followed_posts
      render json: @posts
    else
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
    end
  end

  # def new
  #   if params[:user_id].to_i == Current.user.id
  #     @post_follow = PostFollow.new
  #   end
  # end

  def create
    if params[:user_id].to_i == Current.user.id
      if PostFollow.exists?(user_id: params[:user_id], post_id: params[:post_id])
        render json: { message: "Đã theo dõi trc đó!" }, status: :unprocessable_entity
      end
      @post_follow = PostFollow.new(user_id: params[:user_id], post_id: params[:post_id])
      if @post_follow.save
        render json: { message: "Theo dõi thành công!", post_follow: @post_follow }, status: :created
      else
        render json: { message: "Theo dõi thất bại" }, status: :unprocessable_entity
      end
    else
      head :forbidden
    end
  end

  def destroy
    if params[:user_id].to_i == Current.user.id
      @post_follow = PostFollow.find_by(user_id: params[:user_id], post_id: params[:post_id])
      @post_follow&.destroy
      render json: { message: "Xoa ok" }
    end
  end
end
