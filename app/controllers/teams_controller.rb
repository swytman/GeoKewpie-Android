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
      params[:team].permit(:title, :status)
    end



end
