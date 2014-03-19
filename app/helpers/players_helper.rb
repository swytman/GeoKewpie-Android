module PlayersHelper
  def player_total_cards champ, player_id
    games = champ.games
    yellow_cards, dbl_yellow_cards, red_cards = 0, 0, 0
    games.each do |g|
      yellow_cards += 1 if g.yellow_cards.present? && g.yellow_cards.include?(player_id)
      dbl_yellow_cards += 1 if g.dbl_yellow_cards.present? && g.dbl_yellow_cards.include?(player_id)
      red_cards += 1 if g.red_cards.present? && g.red_cards.include?(player_id)
    end
    return {yellow_cards: yellow_cards, dbl_yellow_cards: dbl_yellow_cards, red_cards: red_cards}
  end

  def player_total_goals champ, player_id
    games = champ.games
    goals = 0
    games.each do |g|
      goals +=g.player_goals(player_id).to_i unless g.player_goals(player_id).nil?
    end
    return goals
  end

  def player_total_games champ, player_id
    games = champ.games
    count = 0
    games.each do |g|
      count += g.player? player_id
    end
    return count
  end



end