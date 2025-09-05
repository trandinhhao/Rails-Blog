class PostRatingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    if Post.exists?(id: params[:post_id])
      ratings_count = PostRating.where(post_id: params[:post_id]).group(:star).count
      render json: ratings_count
    else
      render json: { message: "Khong ton tai post!" }, status: :unprocessable_entity
    end
  end

  def create
    if params[:user_id].to_i == Current.user.id
      if PostRating.exists?(user_id: params[:user_id], post_id: params[:post_id])
        render json: { message: "Đã rate trc đó!" }, status: :unprocessable_entity and return
      end
      @post_rating = PostRating.new(user_id: params[:user_id], post_id: params[:post_id], star: params[:star])
      if @post_rating.save
        render json: { message: "Rate thành công!", post_rating: @post_rating }, status: :created
      else
        render json: { message: "Rate thất bại!" }, status: :unprocessable_entity
      end
    else
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
    end
  end

  def update
    if params[:user_id].to_i == Current.user.id
      @post_rating ||= PostRating.find_by(user_id: params[:user_id], post_id: params[:post_id])
      if @post_rating != nil
        @post_rating.update(star: params[:star])
        render json: {message: "Cap nhat ok!", post_rating: @post_rating}, status: :ok
      else
        render json: {message: "Khong tim thay rating"}, status: :unprocessable_entity
      end
    else
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:user_id].to_i == Current.user.id
      @post_rating ||= PostRating.find_by(user_id: params[:user_id], post_id: params[:post_id])
      @post_rating&.destroy
      render json: { message: "Xoa ok" }, status: :ok
    else
      render json: { message: "Không được phép!" }, status: :unprocessable_entity
    end
  end
end
