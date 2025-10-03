class BooksController < ApplicationController

  def index
    @book = Book.new
    @books =
      case params[:sort]
      when 'rate'  then Book.highest_rated   # 評価の高い順
      else               Book.latest         # 新着順（デフォルト）
      end
  end

  def show
    @book_detail = Book.find(params[:id])
    @book        = Book.new
    @post_comment = PostComment.new

    session[:viewed_books] ||= []
    unless session[:viewed_books].include?(@book_detail.id)
      @book_detail.increment!(:view_count)
      session[:viewed_books] << @book_detail.id
    end
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end
end
