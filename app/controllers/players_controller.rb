class PlayersController < ApplicationController

  before_action :set_player, only: [:show, :edit, :update, :destroy]

  def index
    @players = Player.all
  end

  def new
    @player = Player.new
  end

  def edit

  end

  def show
  end

  def create
    if @player = Player.create(player_params)
      redirect_to edit_player_path(@player), notice: 'Игрок добавлен'
    else
      render action: 'new', error: 'Ошибка при добавлении'
    end
  end

  def destroy
    if @player.destroy
      redirect_to players_path, notice: 'Игрок удален'
    else
      render action: 'edit', error: 'Ошибка при удалении'
    end
  end

  def update
    if @player.update_attributes(player_params)
      redirect_to players_path, notice: 'Данные по игроку обновлены'
    else
      render action: 'edit', error: 'Ошибка при обновлении'
    end

  end

  private
  def set_player
    @player = Player.find(params[:id])
  end
  def player_params
    params[:player][:birthdate] = Date.strptime(params[:player][:birthdate], "%d/%m/%Y") if params[:player][:birthdate].present?
    params[:player].permit(:name, :surname, :middlename, :phone, :birthdate)
  end
end
