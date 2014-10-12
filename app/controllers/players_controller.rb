class PlayersController < ApplicationController

  before_action :set_player, only: [:show, :edit, :update, :destroy]

  def index
    @players = Player.all
  end

  def new
    authorize! :manage, Player
    @player = Player.new
  end

  def edit
    authorize! :manage, Player
  end

  def show
  end

  def create
    authorize! :manage, Player
    team_ids = params[:contract][:team_ids]
    @player = Player.new(player_params)
    if @player.save
      unless team_ids.nil?
        hash = {player_id: @player.id, team_id: team_ids.first.to_i, join_date: Time.now}
        Contract.create(hash)
      end
      redirect_to request.referer, notice: 'Игрок добавлен'
    else
      render 'new', notice: 'Ошибка при добавлении'
    end
  end

  def destroy
    authorize! :manage, Player
    if @player.destroy
      redirect_to players_path, notice: 'Игрок удален'
    else
      render action: 'edit', error: 'Ошибка при удалении'
    end
  end

  def update
    authorize! :manage, Player
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
    params[:player][:number] = params[:player][:number] if params[:player][:number].present?
    params[:player].permit(:name, :surname, :middlename, :phone, :birthdate, :number)
  end
end
