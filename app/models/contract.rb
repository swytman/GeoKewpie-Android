class Contract < ActiveRecord::Base
  belongs_to :team
  has_one :champ, through: :team
  belongs_to :player

  scope :active,  -> {where(leave_date: nil)}
  scope :old,  -> {where.not(leave_date: nil)}

  def close
    self.leave_date = Time.now
  end

  def self.active_players_in_teams t_ids
    ids = Contract.active.where(team_id: t_ids).collect(&:player_id).compact
    Player.where(id: ids)
  end

  def self.old_players_in_teams t_ids
    ids = Contract.old.where(team_id: t_ids).collect(&:player_id).compact
    Player.where(id: ids)
  end

  def decrease_disq
    self.disq_games -= 1 if self.disq_games>0
    save
  end

  def calc_total_games
    games = champ.games.where("home_id = #{team_id} OR visiting_id = #{team_id}")
    count = 0
    games.each do |g|
      count += g.player?(player_id)
    end
    count
  end

  def calc_total_goals
    games = champ.games.where("home_id = #{team_id} OR visiting_id = #{team_id}")
    goals = 0
    games.each do |g|
      goals +=g.player_goals(player_id).to_i unless g.player_goals(player_id).nil?
    end
    return goals
  end

  def calc_cards
    games = champ.games.where("home_id = #{team_id} OR visiting_id = #{team_id}")
    yellow_cards, dbl_yellow_cards, red_cards = 0, 0, 0
    games.each do |g|
      yellow_cards += 1 if g.yellow_cards.present? && g.yellow_cards.include?(player_id)
      dbl_yellow_cards += 1 if g.dbl_yellow_cards.present? && g.dbl_yellow_cards.include?(player_id)
      red_cards += 1 if g.red_cards.present? && g.red_cards.include?(player_id)
    end
    return {yellow_cards: yellow_cards, dbl_yellow_cards: dbl_yellow_cards, red_cards: red_cards}
  end

  def calc flags = []
    self.games = calc_total_games
    self.goals = calc_total_goals
    cards = calc_cards
    old_y_cards = y_cards + dbl_cards
    self.y_cards = cards[:yellow_cards]
    old_dbl_cards = dbl_cards
    self.dbl_cards = cards[:dbl_yellow_cards]
    old_r_cards = r_cards
    self.r_cards = cards[:red_cards]
    unless flags.include?(:ignore_disq)
      if (old_y_cards < (y_cards + dbl_cards) && ((y_cards + dbl_cards) % 3 == 0)) ||
          (old_dbl_cards < cards[:dbl_yellow_cards]) || (old_r_cards < cards[:red_cards])
        self.disq_games = 1
      end
    end
    save
  end

  def self.recalculate_players_stats champ, t_id, game_player_ids, all_player_ids = nil, flags = []
    contracts = Contract.where(player_id: game_player_ids).where(team_id: t_id)
    contracts.each do |contract|
      contract.calc flags
    end
    # уменьшим число дисквалификций

    if all_player_ids.present?
      missing_player_ids = all_player_ids - game_player_ids
      Contract.where(player_id: missing_player_ids).keep_if{|p| p.champ == champ}.each do |contract|
        contract.decrease_disq
      end
    end
  end
end
