class Player < ActiveRecord::Base
  has_many :teams, through: :contracts
  has_many :contracts, dependent: :destroy
  has_many :champs, through: :teams

  scope :default_scope,  -> { order([:surname, :name]) }

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



  def team_in_champ champ_id, ch_team_ids = nil
    ch_team_ids ||= Champ.find(champ_id).team_ids
    id = team_ids & ch_team_ids
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

  def get_total_games champ

  end

  def get_total_cards champ

    return {yellow_cards: yellow_cards, dbl_yellow_cards: dbl_yellow_cards, red_cards: red_cards}
  end

  def get_total_goals champ

  end


end
