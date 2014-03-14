class ChampsController < ApplicationController
  before_action :set_champ, only: [:show, :edit, :update, :destroy]

  def index
    @champs = Champ.all
  end
  def show

  end

  def new
    @champ = Champ.new
  end

  def edit
  end

  def create
    @champ = Champ.new(champ_params)
    if @champ.save
      redirect_to edit_champ_path(@champ), notice: 'OK'
    else
      render action: 'new', error: 'Ошибка при добавлении'
    end
  end

  def destroy
    if @champ.destroy
      redirect_to champs_path, notice: 'OK'
    else
      redirect_to edit_champ_path(@champ), error: 'Ошибка при удалении'
    end
  end

  def update
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
    params[:champ].permit(:title, :champ_type, :status,
                          :description)
  end
end
