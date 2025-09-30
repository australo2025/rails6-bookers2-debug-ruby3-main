class PostCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @post_comment = current_user.post_comments.new(post_comment_params.merge(book: @book))

    if @post_comment.save
      respond_to do |format|
        format.html { redirect_to book_path(@book) }
        format.js   # ← create.js.erb を返す
      end
    else
      # 失敗時もひとまず同期遷移でOK（簡易）
      redirect_to book_path(@book)
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    @post_comment = PostComment.find(params[:id])  # 簡易。自分のだけにしたいなら current_user.post_comments.find
    @post_comment.destroy

    respond_to do |format|
      format.html { redirect_to book_path(@book) }
      format.js   # ← destroy.js.erb を返す
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end