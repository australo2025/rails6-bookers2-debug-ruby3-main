class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    today           = Time.zone.today
    today_range     = today.all_day
    yesterday_range = (today - 1).all_day
  
    week_start      = today.beginning_of_week(:saturday)
    week_end        = today.end_of_week(:friday)
    this_week_range = week_start.beginning_of_day..week_end.end_of_day
  
    last_week_range = (week_start - 7).beginning_of_day..(week_end - 7).end_of_day
  
    @count_today      = @user.books.where(created_at: today_range).count
    @count_yesterday  = @user.books.where(created_at: yesterday_range).count
    @count_this_week  = @user.books.where(created_at: this_week_range).count
    @count_last_week  = @user.books.where(created_at: last_week_range).count
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end