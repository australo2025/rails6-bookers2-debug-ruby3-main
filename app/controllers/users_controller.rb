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
    from = 6.days.ago.beginning_of_day
    to   = Time.current.end_of_day

    dates = (from.to_date..Date.current).to_a
    counts_by_date = @user.books.where(created_at: from..to)
                         .pluck(:created_at)                 # DBから時刻を取り出し
                         .map { |t| t.in_time_zone.to_date } # RailsのTZで日付に変換
                         .tally                               # {Date=>件数}
    @counts = dates.map { |d| counts_by_date[d] || 0 }
    @labels = dates.map { |d| d == Date.current ? "今日" : "#{(Date.current - d).to_i}日前" }
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

  def search
    @user = User.find(params[:id])
    selected_date = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    @daily_count  = @user.books.where(created_at: selected_date.all_day).count

    respond_to do |format|
      format.js
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