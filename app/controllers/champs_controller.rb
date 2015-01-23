class ChampsController < ApplicationController
  before_action :set_champ, only: [:show, :edit, :update, :destroy, :teams, :cup, :stats, :schedule, :disq]

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
    if @champ.have_ring_stage
      redirect_to teams_champ_path(@champ)
      return
    end

    if @champ.have_cup_stage
      redirect_to cup_champ_path(@champ)
      return
    end

    redirect_to schedule_champ_path(@champ)

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

  def disq
    @contracts = @champ.contracts.where.not(disq_games: [nil, 0]).includes(:team, :player)
  end

  def cup
    @stage = @champ.stages.find_by(stage_type: 'плей-офф')
    @tour_stages_ar = @stage.games.map(&:tour_id).uniq.compact.sort

    @games_cnt_by_stage = []

    @tour_stages_ar.each do |stage|
      cnt = @stage.games.where(tour_id: stage).count
      @games_cnt_by_stage << cnt
    end

    @canvas_width = @games_cnt_by_stage.length * 150
    @canvas_height = @games_cnt_by_stage.max * 100

  end

  private

  def set_champ
    @champ = Champ.includes(:stages).find(params[:id])
  end

  def champ_params
    result =
      params[:champ].permit(:title, :champ_type, :status,
                            :order_priority, :label_css_schema,
                            :description, :group_key, :y_cards_limit)
    result[:order_priority] = result[:order_priority].to_i if result[:order_priority].present?
    result
  end
end
