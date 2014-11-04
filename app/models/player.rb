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

  def self.recalculate_players_stats champ, game_player_ids, all_player_ids = nil
    contracts = Contract.where(player_id: game_player_ids).keep_if{|p| p.champ == champ}
    contracts.each do |contract|
      contract.games = Player.player_total_games(champ, contract.player_id)
      contract.goals = Player.player_total_goals(champ, contract.player_id)
      cards = Player.player_total_cards(champ, contract.player_id)
      old_y_cards = contract.y_cards + contract.dbl_cards
      contract.y_cards = cards[:yellow_cards]
      old_dbl_cards = contract.dbl_cards
      contract.dbl_cards = cards[:dbl_yellow_cards]
      old_r_cards = contract.r_cards
      contract.r_cards = cards[:red_cards]
      if (old_y_cards < (contract.y_cards + contract.dbl_cards) && ((contract.y_cards + contract.dbl_cards) % 3 == 0)) ||
          (old_dbl_cards < cards[:dbl_yellow_cards]) || (old_r_cards < cards[:red_cards])
          contract.disq_games = 1
      end
      contract.save
    end
    # уменьшим число дисквалификций
    if all_player_ids.present?
      missing_player_ids = all_player_ids - game_player_ids
      Contract.where(player_id: missing_player_ids).keep_if{|p| p.champ == champ}.each do |contract|
        contract.decrease_disq
      end
    end


  end

  def self.player_total_games champ, player_id
    games = champ.games
    count = 0
    games.each do |g|
      count += g.player?(player_id)
    end
    count
  end

  def self.player_total_cards champ, player_id
    games = champ.games
    yellow_cards, dbl_yellow_cards, red_cards = 0, 0, 0
    games.each do |g|
      yellow_cards += 1 if g.yellow_cards.present? && g.yellow_cards.include?(player_id)
      dbl_yellow_cards += 1 if g.dbl_yellow_cards.present? && g.dbl_yellow_cards.include?(player_id)
      red_cards += 1 if g.red_cards.present? && g.red_cards.include?(player_id)
    end
    return {yellow_cards: yellow_cards, dbl_yellow_cards: dbl_yellow_cards, red_cards: red_cards}
  end

  def self.player_total_goals champ, player_id
    games = champ.games
    goals = 0
    games.each do |g|
      goals +=g.player_goals(player_id).to_i unless g.player_goals(player_id).nil?
    end
    return goals
  end


end
