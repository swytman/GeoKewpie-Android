class GamesController < ApplicationController
  include GamesHelper
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :set_stage
  before_action :set_champ

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def show
  end

  def edit
  end


  def create
    @game = @stage.games.new(game_params)
    trigger_status
    if @game.save
      if @game.status == Game.status[2]
        calculate
      end
      redirect_to champ_stage_path(@champ, @stage), notice: 'OK'
    else
      render action: 'new', error: 'Ошибка при добавлении'
    end
  end

  def destroy
    if @game.destroy
      redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
    else
      render action: 'edit', error: 'Ошибка при удалении'
    end
  end

  def update
    trigger_status
    if @game.update_attributes(game_params)
      if @game.status == Game.status[2]
        calculate
      end
      redirect_to edit_champ_stage_path(@champ, @stage), notice: 'OK'
    else
      render action: 'show', error: 'Ошибка при обновлении'
    end

  end

  private
  def trigger_status
    reset_result
    if game_params[:home_scores].present? && game_params[:visiting_scores].present?
      @game.status = Game.status[2]
      fill_result game_params[:home_scores].to_i, game_params[:visiting_scores].to_i
    elsif game_params[:date].present?
      @game.status = Game.status[1]
    else
      @game.status = Game.status[0]
    end
  end

  def reset_result
    @game.home_points = nil
    @game.visiting_points = nil
    @game.winner_id = nil
  end

  def calculate
    if @stage.stage_type == 'круг'
      Team.calculate_ring(@game.home_id)
      Team.calculate_ring(@game.visiting_id)
    end
  end

  def fill_result home_scores, visiting_scores
    if @stage.stage_type == 'круг'
      fill_result_ring home_scores, visiting_scores
    end
  end

  def fill_result_ring home_scores, visiting_scores
    if home_scores > visiting_scores
      @game.home_points = result_points[:win]
      @game.visiting_points = result_points[:lose]
      @game.winner_id = @game.home_id
    elsif home_scores < visiting_scores
      @game.home_points = result_points[:lose]
      @game.visiting_points = result_points[:win]
      @game.winner_id = @game.visiting_id
    elsif home_scores == visiting_scores
      @game.home_points = result_points[:draw]
      @game.visiting_points = result_points[:draw]
      @game.winner_id = 0
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
    params[:game].permit(:date, :time, :home_id, :visiting_id, :tour_id, :home_scores, :visiting_scores)
  end

end