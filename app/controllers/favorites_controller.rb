class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    book = Book.find(params[:book_id])
    current_user.favorites.create!(book_id: book.id)
    redirect_back fallback_location: book_path(book)
  end

  def destroy
    book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by!(book_id: book.id)
    favorite.destroy
    redirect_back fallback_location: book_path(book)
  end
end