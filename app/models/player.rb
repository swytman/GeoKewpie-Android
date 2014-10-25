class Player < ActiveRecord::Base
  has_many :teams, through: :contracts
  has_many :contracts
  has_many :champs, through: :teams

  scope :default_scope,  -> {order([:surname, :name])}

  validates :surname, presence: true
  validates :name, presence: true

  def full_name
    "#{surname} #{name} #{middlename}"
  end

  def short_name
    "#{surname} #{letter_name} #{letter_middlename} #{number_text}"
  end

  def number_text
    "№#{number}" if number.present?
  end

  def letter_name
    self.name.capitalize[0]+'.' unless name.blank?
  end

  def letter_middlename
    self.middlename.capitalize[0]+'.' unless middlename.blank?
  end



  def team_in_champ champ_id
    id = team_ids & Champ.find(champ_id).team_ids
    Team.find(id[0])
  end

  def current_teams
    ids = contracts.active.collect(&:team_id)
    Team.where(id: ids)
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
