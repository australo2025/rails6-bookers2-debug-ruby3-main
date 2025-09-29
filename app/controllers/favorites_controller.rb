class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    current_user.favorites.create!(book_id: @book.id)
    respond_to do |format|                                      # ← 追加
      format.html { redirect_back fallback_location: book_path(@book) }
      format.js
  end
end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by!(book_id: @book.id).destroy
    respond_to do |format|                                      # ← 追加
      format.html { redirect_back fallback_location: book_path(@book) }
      format.js
  end
end
end