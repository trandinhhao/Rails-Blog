class PostRatingsController < ApplicationController
  def index
    @post = Post.find(params[:post_id])
    @check = PostRating.exists?(user_id: Current.user.id, post_id: params[:post_id])
    @ratings_count = PostRating.where(post_id: params[:post_id]).group(:star).count
  end

  def new
    @post = Post.find(params[:post_id])
    @post_rating = PostRating.new
  end

  def create
    if params[:user_id].to_i != Current.user.id
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
      return
    end

    if PostRating.exists?(user_id: params[:user_id], post_id: params[:post_id])
      render json: { message: "Đã rate trc đó!" }, status: :unprocessable_entity
      return
    end

    @post_rating = PostRating.new(user_id: params[:user_id], post_id: params[:post_id], star: params[:star])
    if @post_rating.save
      redirect_to user_post_post_ratings_path(params[:user_id],params[:post_id])
    else
      render json: { message: "Rate thất bại!" }, status: :unprocessable_entity
    end
  end

  # def edit
  #   @post_rating ||= PostRating.find_by(user_id: params[:user_id], post_id: params[:post_id])
  # end

  # def update
  #   if params[:user_id].to_i != Current.user.id
  #     render json: { message: "Không được phép!" }, status: :unprocessable_entity
  #     return
  #   end
  #
  #   @post_rating ||= PostRating.find_by(user_id: params[:user_id], post_id: params[:post_id])
  #   if @post_rating != nil
  #     @post_rating.update(star: params[:star])
  #     render json: {message: "Cap nhat ok!", post_rating: @post_rating}, status: :ok
  #     return
  #   else
  #     render json: {message: "Khong tim thay rating"}, status: :unprocessable_entity
  #     return
  #   end
  # end

  def destroy
    if params[:user_id].to_i == Current.user.id
      @post_rating ||= PostRating.find_by(user_id: params[:user_id], post_id: params[:post_id])
      @post_rating&.destroy
      render json: { message: "Xoa ok" }, status: :ok
      return
    else
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
      return
    end
  end
end
