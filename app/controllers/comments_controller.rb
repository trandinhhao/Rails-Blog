class CommentsController < ApplicationController
  before_action :set_post, only: %i[ index new ]

  def index
    @post = Post.find(params[:post_id])
    @user = User.find_by(id: @post.user_id)
    @comments = Comment.where(post_id: params[:post_id], parent_id: nil).order(created_at: :asc)
  end

  def new
    @user = Current.user
    @comment = @post.comments.build(parent_id: params[:parent_id])
  end

  def create
    @comment = Comment.new(params.permit(:content, :parent_id))
    @comment.user_id = Current.user.id
    @comment.post_id = params[:post_id].to_i
    if @comment.save
      redirect_to post_comments_path(params[:post_id])
    else
      render json: { message: "Cmt thất bại" }, status: :unprocessable_entity
    end
  end

  # def destroy
  #   @comment ||= Comment.find(params[:id])
  #   @comment&.destroy
  #   render json: { message: "Da thuc hien thao tac xoa!" }, status: :unprocessable_entity
  # end

  private
  def set_post
    @post ||= Post.find(params[:post_id])
  end

end
