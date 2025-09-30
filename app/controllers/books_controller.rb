class BooksController < ApplicationController

  def index
    @book  = Book.new
    @books = Book
               .left_joins(:favorites)                                # ❶ いいねを結合（0件の本も残す）
               .select('books.*, COUNT(favorites.id) AS likes_count') # ❷ 本ごとの いいね数 を列に付ける
               .group('books.id')                                     # ❸ 重複行をまとめる（集計の必須条件）
               .order('likes_count DESC, books.id DESC')              # ❹ いいね数の多い順（同点は新しい順）
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
    params.require(:book).permit(:title, :body)
  end
end
