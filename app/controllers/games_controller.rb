class GamesController < ApplicationController
  include GamesHelper
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :set_stage
  before_action :set_champ
  after_action :trigger_status, only: [:create, :update]

  def index
    @games = Game.all
  end

  def new
    authorize! :manage, Game
    @game = Game.new
  end

  def show

  end

  def edit
    authorize! :manage, Game
    if @game.home_team.present?
      @home_players = @game.home_team.players | @game.home_team.old_players
    end
    if @game.visiting_team.present?
      @visiting_players= @game.visiting_team.players | @game.visiting_team.old_players
    end
  end


  def create
    authorize! :manage, Game
    @game = @stage.games.new(game_params)
    if @game.save
      redirect_to champ_stage_path(@champ, @stage), notice: 'OK'
    else
      render action: 'new', error: 'Ошибка при добавлении'
    end
  end

  def destroy
    authorize! :manage, Game
    if @game.destroy
      redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
    else
      render action: 'edit', error: 'Ошибка при удалении'
    end
  end

  def update
    authorize! :manage, Game
    if @game.update_attributes(prepared_params game_params)
      redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
    else
      render action: 'show', error: 'Ошибка при обновлении'
    end

  end

  private
  def trigger_status
    @game.reset_result
    if game_params[:home_scores].present? && game_params[:visiting_scores].present?
      @game.status = Game.status[2]
      @game.fill_result
    elsif game_params[:date].present?
      @game.status = Game.status[1]
    else
      @game.status = Game.status[0]
    end
    @game.save
    calculate if @game.status == Game.status[2]
  end

  def calculate
    if @stage.stage_type == 'круг'
      Team.calculate_ring(@game.home_id)
      Team.calculate_ring(@game.visiting_id)
    end
  end

  def set_champ
    @champ = Champ.find(params[:champ_id])
  end
  def set_stage
    @stage = Stage.find(params[:stage_id])
  end
  def set_game
    @game = Game.find(params[:id])
  end

  def game_params

    params[:game].permit( :date, :time, :home_id, :visiting_id, :tour_id, :home_scores, :visiting_scores,
                          :yellow_cards, :dbl_yellow_cards, :red_cards, :home_players, :visiting_players,
                          :player_scores )
  end

  def prepared_params p
    p[:yellow_cards] = p[:yellow_cards].split(',').collect{|i| i.to_i} unless p[:yellow_cards].class == Array
    p[:dbl_yellow_cards] = p[:dbl_yellow_cards].split(',').collect{|i| i.to_i} unless p[:dbl_yellow_cards].class == Array
    p[:red_cards] = p[:red_cards].split(',').collect{|i| i.to_i} unless p[:red_cards].class == Array
    p[:home_players] = p[:home_players].split(',').collect{|i| i.to_i} unless p[:home_players].class == Array
    p[:visiting_players] = p[:visiting_players].split(',').collect{|i| i.to_i} unless p[:visiting_players].class == Array
    p[:player_scores] = p[:player_scores].split(',')
    p
  end

end