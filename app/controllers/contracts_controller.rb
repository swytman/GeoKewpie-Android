class ContractsController < ApplicationController

  before_action :set_champ
  before_action :set_team
  before_action :set_contract, only: [:show, :edit, :update, :destroy]
  before_action :close_contract, only: [:create]


  def new
    @contract = Contract.new
  end

  def edit

  end

  def show
  end

  def create
    if @contract = Contract.create(contract_params)
      redirect_to edit_champ_team_path(@champ,@team), notice: 'Игрок добавлен'
    else
      render action: 'new', error: 'Ошибка при добавлении'
    end
  end

  def destroy
    if @contract.destroy
      redirect_to edit_team_path(@champ,@team), notice: 'Игрок удален'
    else
      render action: 'edit', error: 'Ошибка при удалении'
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
  def contract_params
    p = params[:contract].permit(:player_id, :join_date, :leave_date)
    p[:team_id] = @team.id
    p[:join_date] = Time.now
    return p
  end

  def close_contract
    contract = Contract.active.where(player_id: contract_params[:player_id]).reject{|c| c.champ.id!=@champ.id}
    if contract.present?
      contract = contract[0]
      contract.leave_date = Time.now
      contract.save!
    end
  end

end