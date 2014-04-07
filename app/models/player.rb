class Player < ActiveRecord::Base
  has_many :teams, through: :contracts
  has_many :contracts
  has_many :champs, through: :teams

  scope :default_scope,  -> {order([:surname, :name])}

  def full_name
    "#{surname} #{name} #{middlename}"
  end



  def team_in_champ champ_id
    if Champ.find(champ_id).player_ids.include? id
      id = team_ids & Champ.find(champ_id).team_ids
      Team.find(id[0])
    else
      nil
    end
  end
  def current_teams
    contracts.active.collect {|i| Team.find(i.team_id)}
  end

  def current_contracts
    contracts.active
  end

  def old_contracts
    contracts.old
  end


  def signed_text champ_id
    team = team_in_champ champ_id
    if team.present?
      ["Игрок заявлен за команду #{team.title}", "Трансфер"]
    else
      ["Игрок не заявлен ни за одну команду в этом чемпионате", "Заявить"]
    end
  end



end
