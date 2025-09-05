class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    # @user = User.find(params[:user_id])
    # @post = Post.find(params[:post_id])
    @comments = Comment.where(post_id: params[:post_id])
    render json: @comments
  end

  # def new
  #   @user = Current.user
  #   @post = Post.find(params[:post_id])
  #   @comment = @post.comments.build(parent_id: params[:parent_id])
  # end

  def create
    @comment = Comment.new(params.permit(:content, :parent_id))
    @comment.user_id = Current.user.id
    @comment.post_id = params[:post_id].to_i
    if @comment.save
      render json: { message: "Cmt ok" }, status: :ok
    else
      render json: { message: "Cmt thất bại" }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment ||= Comment.find(params[:id])
    @comment&.destroy
    render json: { message: "Da thuc hien thao tac xoa!" }, status: :unprocessable_entity
  end
end
