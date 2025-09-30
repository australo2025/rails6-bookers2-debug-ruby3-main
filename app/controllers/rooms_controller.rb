class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    other = User.find(params[:user_id])

    # 相互フォローでなければ部屋を作らない（最小挙動：元ページへ戻す）
    unless current_user.mutual_follow?(other)
      return redirect_back fallback_location: user_path(other)
    end

    # 既存の1対1ルームがあればそれを使う（なければ作る）
    room = (current_user.rooms & other.rooms).first
    unless room
      room = Room.create!
      Entry.create!(user: current_user, room: room)
      Entry.create!(user: other,      room: room)
    end

    redirect_to room_path(room)
  end

  def show
    @room = Room.find(params[:id])

    # 参加者以外は入れない（最小挙動：トップへ）
    unless @room.users.exists?(current_user.id)
      return redirect_to root_path
    end

    @messages = @room.messages.includes(:user).order(:created_at)
    @message  = Message.new
    @other    = (@room.users - [current_user]).first  # 見出し用：相手ユーザー
  end
end