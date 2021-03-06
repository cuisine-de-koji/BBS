class CommentsController < ApplicationController
  def show
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id if current_user

    if @comment.save
      redirect_to post_path(@post), notice: 'コメントの投稿に成功しました。'
    else
      flash.now[:alert] = "コメントの投稿に失敗しました。"
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])

    unless @comment.can_be_edited_by_user?(current_user)
      redirect_to @post, alert: '他のユーザーのコメントは編集できません。'
    end
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])

    unless @comment.can_be_edited_by_user?(current_user)
      redirect_to @post, alert: '他のユーザーのコメントは編集できません。'
    end

    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'コメントのアップデートが成功しました。'
    else
      flash.now[:alert] = "コメントのアップデートが失敗しました。"
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])

    unless @comment.can_be_edited_by_user?(current_user)
      redirect_to @post, alert: '他のユーザーのコメントは編集できません。'
    end

    if @comment.destroy
      redirect_to @post, notice: 'コメントが削除されました。'
    else
      flash.now[:alert] = "コメントの削除に失敗しました。"
      render 'edit'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
