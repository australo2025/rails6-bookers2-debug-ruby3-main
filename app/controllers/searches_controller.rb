class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @word  = params[:word].to_s
    range  = params[:range]
    match  = params[:match]

    if range == "User"
      @users = User.search_for(@word, match)
    else
      @books = Book.search_for(@word, match)
    end
  end
end