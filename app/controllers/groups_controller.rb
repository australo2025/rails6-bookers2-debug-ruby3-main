class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :join, :leave]
  before_action :ensure_owner!, only: [:edit, :update]

  def index
    @groups = Group.all
  end

  def show; end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user  # 作成者＝オーナー
    if @group.save
      redirect_to @group, notice: "グループを作成しました"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: "更新しました"
    else
      render :edit
    end
  end

  def join
    @group.group_users.find_or_create_by!(user_id: current_user.id)
    redirect_back fallback_location: group_path(@group)
  end

  def leave
    @group.group_users.where(user_id: current_user.id).destroy_all
    redirect_back fallback_location: group_path(@group)
  end

  private
  def set_group
    @group = Group.find(params[:id])
  end

  def ensure_owner!
    redirect_to groups_path, alert: "権限がありません" unless @group.owner == current_user
  end

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end