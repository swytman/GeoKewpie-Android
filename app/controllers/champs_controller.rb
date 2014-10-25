class ChampsController < ApplicationController
  before_action :set_champ, only: [:show, :edit, :update, :destroy, :teams, :stats, :schedule]

  def index
    @type = params[:type]
    @champs =
      if @type.present? && Champ.type.include?(@type)
        Champ.where(champ_type: @type).includes(:games).includes(:teams)
      else
        Champ.all.includes(:games).includes(:teams)
      end
  end

  def show
    redirect_to teams_champ_path(@champ)
  end


  def new
    authorize! :manage, Champ
    @champ = Champ.new
  end

  def edit
    authorize! :manage, Champ
  end

  def create
    authorize! :manage, Champ
    @champ = Champ.new(champ_params)
    if @champ.save
      redirect_to edit_champ_path(@champ), notice: 'OK'
    else
      render action: 'new', error: 'Ошибка при добавлении'
    end
  end

  def destroy
    authorize! :manage, Champ
    if @champ.destroy
      redirect_to champs_path, notice: 'OK'
    else
      redirect_to edit_champ_path(@champ), error: 'Ошибка при удалении'
    end
  end

  def update
    authorize! :manage, Champ
    if @champ.update_attributes(champ_params)
      redirect_to edit_champ_path(@champ), notice: 'OK'
    else
      render action: 'edit', error: 'Ошибка при обновлении'
    end

  end

  private

  def set_champ
    @champ = Champ.includes(:stages).find(params[:id])
  end

  def champ_params
    result =
      params[:champ].permit(:title, :champ_type, :status,
                            :order_priority, :label_css_schema,
                            :description, :group_key)
    result[:order_priority] = result[:order_priority].to_i if result[:order_priority].present?
    result
  end
end
