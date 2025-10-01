class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update]
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

  private
  def set_group
    @group = Group.find(params[:id])
  end

  def ensure_owner!
    redirect_to groups_path, alert: "権限がありません" unless @group.owner == current_user
  end

  def group_params
    # 画像を使う場合は :image を足す（ActiveStorage/reamfileで名称は合わせる）
    params.require(:group).permit(:name, :introduction)
  end
end