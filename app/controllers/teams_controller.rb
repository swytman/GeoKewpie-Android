class TeamsController < ApplicationController

  before_action :set_champ
  before_action :set_stages, only: [:games]
  before_action :set_team, only: [:show, :edit, :update, :destroy, :players, :games]


  def index
    @teams = Team.all
  end

  def new
    authorize! :manage, Stage
    @team = Team.new
  end

  def edit
    authorize! :manage, Stage
  end

  def show
    redirect_to games_champ_team_path(@champ, @team)
  end

  def create
    authorize! :manage, Stage
    if @team = @champ.teams.create(team_params)
      redirect_to edit_champ_path(@champ), notice: 'Команда успешно добавлена'
    else
      render action: 'new', error: 'Ошибка при добавлении'
    end
  end

  def destroy
    authorize! :manage, Stage
    if @team.destroy
      redirect_to edit_champ_path(@champ), notice: 'Команда успешно удалена'
    else
      redirect_to edit_champ_team_path(@champ, @team), error: 'Ошибка при удалении'
    end
  end

  def update
    authorize! :manage, Stage
    if @team.update_attributes(team_params)
      redirect_to edit_champ_team_path(@champ, @team), notice: 'Команда обновлена'
    else
      render action: 'edit', error: 'Ошибка при обновлении'
    end

  end

  def clone
    @sel_champ_id = params[:sel_champ_id]
    @champs = Champ.where.not(id: @champ.id).alive.map{ |c| [c.title, c.id] }
    if @sel_champ_id.present?
      @sel_champ = Champ.find(@sel_champ_id)
      @teams = @sel_champ.teams.map{ |t| [t.title, t.id] }
      @sel_champ = [ @sel_champ.title, @sel_champ_id.to_i ]
    end
    @sel_team_id = params[:sel_team_id]
    if @sel_team_id.present?
      @sel_team = [ Team.find(@sel_team_id).title, @sel_team_id.to_i ]
    end
  end

  def do_clone
    gage_team = Team.find(params[:team].to_i) if params[:team].present?
    redirect_to request.referer, notice: 'Не указана команда эталон' if gage_team.nil?
    Team.do_clone(@champ, gage_team)
    redirect_to champ_path(@champ), notice: 'Команда создана'
  end




  private
    def set_stages
      @stages = @champ.stages
    end

    def set_champ
      @champ = Champ.find(params[:champ_id])
    end
    def set_team
      @team = Team.find(params[:id])
    end
    def team_params
      params[:team][:win] = 0 if params[:team][:win].blank?
      params[:team][:lose] = 0 if params[:team][:lose].blank?
      params[:team][:draw] = 0 if params[:team][:draw].blank?
      params[:team][:scored] = 0 if params[:team][:scored].blank?
      params[:team][:missed] = 0 if params[:team][:missed].blank?
      params[:team][:points] = 0 if params[:team][:points].blank?
      params[:team][:penalty_points] = 0 if params[:team][:penalty_points].blank?

      params[:team].permit(:title, :status, :team_logo_id, :penalty_points, :win, :lose, :draw, :scored, :missed, :points)
    end



end
