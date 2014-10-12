class TeamLogosController < ApplicationController

  before_action :set_logo, only: [:show, :edit, :update, :destroy]

  def index
    @team_logos = TeamLogo.all
    @team_logo = TeamLogo.new
  end

  def create
    logo = TeamLogo.new(team_logo_params)
    if logo.save
      render :nothing => true
    else
      render 'index', notice: 'Ошибка при добавлении'
    end
  end

  def destroy

  end

  def update

  end

  def edit

  end

private

  def team_logo_params
    params[:team_logo].permit(:logo)
  end

  def set_logo
    @logo = TeamLogo.find(params[:id])
  end

end
