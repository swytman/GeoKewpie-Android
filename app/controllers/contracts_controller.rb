class ContractsController < ApplicationController

  before_action :set_champ, except: [:destroy, :close]
  before_action :set_team,  except: [:destroy, :close]
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :close]
  before_action :fetch_params, only: [:create]


  def new
    @contract = Contract.new
  end

  def edit
  end

  def show
  end

  def create
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
    if @contract.destroy
      redirect_to request.referer, notice: 'Запись удалена'
    else
      redirect_to request.referer, notice: 'Ошибка при удалении'
    end
  end

  def close
    @contract.close
    if @contract.save
      redirect_to request.referer, notice: 'Отзаявлен'
    else
      redirect_to request.referer, notice: 'Ошибка'
    end
  end


  def update
    if @contract.update_attributes(contract_params)
      redirect_to edit_team_path(@team), notice: 'Данные по игроку обновлены'
    else
      render action: 'edit', error: 'Ошибка при обновлении'
    end
  end

  private
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
    ids = params[:contract][:player_ids].reject{|e| e.blank?}
    @remove_ids = @team.player_ids - ids
    @add_ids = ids - @team.player_ids
  end

end