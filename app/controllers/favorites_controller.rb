class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    current_user.favorites.create!(book: @book)

    # 一覧を差し替えるためのソート済みデータ（indexにいた場合だけ使われる）
    @books = Book.left_joins(:favorites)
                 .select('books.*, COUNT(favorites.id) AS likes_count')
                 .group('books.id')
                 .order('likes_count DESC, books.id DESC')

    respond_to do |format|
      format.html { redirect_back fallback_location: book_path(@book) }
      format.js   # => views/favorites/create.js.erb
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    current_user.favorites.find_by!(book: @book).destroy

    @books = Book.left_joins(:favorites)
                 .select('books.*, COUNT(favorites.id) AS likes_count')
                 .group('books.id')
                 .order('likes_count DESC, books.id DESC')

    respond_to do |format|
      format.html { redirect_back fallback_location: book_path(@book) }
      format.js   # => views/favorites/destroy.js.erb
    end
  end
end