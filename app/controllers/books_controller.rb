class BooksController < ApplicationController

  def index
    @book = Book.new

    base = Book.includes(:tag)
    @tag_query = nil
    if params[:tag].present?
      key = params[:tag].to_s.strip.downcase
      base = base.joins(:tag).where('LOWER(tags.name) = ?', key)
    end

    @books =
    case params[:sort]
    when 'rate'
      base.merge(Book.highest_rated)    # ← 必ず base に merge する！
    else
      base.merge(Book.latest)           # ← ここも merge
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
    set_tag_from_form(@book) 
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.includes(:tag).latest
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @book.assign_attributes(book_params)
    set_tag_from_form(@book) 

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

  def set_tag_from_form(book)
    name = params.dig(:book, :tag_name).to_s.strip
    book.tag = if name.present?
                  Tag.find_or_create_by(name: name.downcase)
                else
                  nil
                end
end
end