class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])

    # 参加者チェック（最小挙動：トップへ）
    return redirect_to root_path unless @room.users.exists?(current_user.id)

    @message = @room.messages.build(message_params.merge(user: current_user))
    if @message.save
      redirect_to room_path(@room)
    else
      # 失敗時もひとまず同じ画面へ（簡易）
      redirect_to room_path(@room)
    end
  end

  private
  def message_params
    params.require(:message).permit(:content)
  end
end