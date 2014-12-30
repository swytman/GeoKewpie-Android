class ContractsController < ApplicationController

  before_action :set_champ, only: [:new, :create]
  before_action :set_team,  only: [:new, :create]
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :close]
  before_action :fetch_params, only: [:create]


  def new
    authorize! :manage, Contract
    @contract = Contract.new
  end

  def edit
    authorize! :manage, Contract
  end

  def show
  end

  def create
    authorize! :manage, Contract
    @remove_ids.each do |id|
      contract = Contract.active.find_by(player_id: id, team_id: @team.id)
      contract.close
      contract.save
    end

    @add_ids.each do |id|
      hash = {player_id: id, team_id: @team.id, join_date: Time.now}
      Contract.create(hash)
    end
      redirect_to edit_champ_team_path(@champ,@team), notice: 'Игроки добавлены'
  end

  #def remove
  #  if @contract.destroy
  #    render json: {result: "Удалено"}
  #  else
  #    render json: {result: "Ошибка при удалении"}
  #  end
  #end

  def destroy
    authorize! :manage, Contract
    if @contract.destroy
      redirect_to request.referer, notice: 'Запись удалена'
    else
      redirect_to request.referer, notice: 'Ошибка при удалении'
    end
  end

  def close
    authorize! :manage, Contract
    @contract.close
    if @contract.save
      redirect_to request.referer, notice: 'Отзаявлен'
    else
      redirect_to request.referer, notice: 'Ошибка'
    end
  end


  def update
    authorize! :manage, Contract
    if @contract.update_attributes(contract_params)
      redirect_to request.referer, notice: 'Данные по игроку обновлены'
    else
      render action: 'edit', error: 'Ошибка при обновлении'
    end
  end

  private
  def contract_params
    params[:contract].permit!
    params[:contract][:disq_games] = 0 if params[:contract][:disq_games].to_i < 0
  end

  def set_champ
    @champ = Champ.find(params[:champ_id])
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def fetch_params
    ids = params[:contract][:player_ids].map(&:to_i).reject{|e| e.blank?}
    @remove_ids = @team.player_ids - ids
    @add_ids = ids - @team.player_ids
  end

end