class CommentsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @post = Post.find(params[:post_id])
    @comments = Comment.where(post_id: params[:post_id], parent_id: nil)
  end

  def new
    @user = Current.user
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(parent_id: params[:parent_id])
  end

  def create
    @comment = Comment.new(params.require(:comment).permit(:content, :parent_id))
    @comment.user_id = Current.user.id
    @comment.post_id = params[:post_id].to_i
    @post = Post.find(params[:post_id])
    if @comment.save
      redirect_to user_post_comments_path(params[:user_id], @post)
    else
      redirect_to user_post_comments_path(params[:user_id], @post), notice: "Comment bi loi"
    end
  end
end
