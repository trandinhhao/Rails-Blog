class PostFollowsController < ApplicationController
  def index
    if params[:user_id].to_i != Current.user.id
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
      return
    end

    @user = User.find(params[:user_id])
    @posts = @user.followed_posts
  end

  def new
    if params[:user_id].to_i == Current.user.id
      @post_follow = PostFollow.new
    end
  end

  def create
    if params[:user_id].to_i == Current.user.id
      if PostFollow.exists?(user_id: params[:user_id], post_id: params[:post_id])
        flash[:alert] = "Đã theo dõi trước đó."
        return
      end

      @post_follow = PostFollow.new(user_id: params[:user_id], post_id: params[:post_id])
      if @post_follow.save
        redirect_to user_post_follows_path(Current.user.id), notice: "Follow thanh cong!"
      else
        render json: { message: "Theo dõi thất bại" }, status: :unprocessable_entity
        return
      end
    end
  end

  def destroy
    if params[:user_id].to_i == Current.user.id
      @post_follow = PostFollow.find_by(user_id: params[:user_id], post_id: params[:post_id])
      @post_follow&.destroy
      redirect_to user_post_follows_path(params[:user_id])
    end
  end
end
