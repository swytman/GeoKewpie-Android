module GamesHelper
  def tours_titles stage
    if stage.stage_type != 'плей-офф'
      tour_ring_titles stage
    else
      tour_play_off_titles
    end
  end

  def tour_play_off_titles
    [['1/128', 128], ['1/64', 64], ['1/32', 32], ['1/16', 16], ['1/8', 8], ['1/4', 4], ['полуфинал', 2], ['финал', 1]]
  end

  # нумерация туров должна продолжать в следующем круге
  def tour_correction stage, team_count
    stages_ids = stage.champ.stages.order(:id).collect{|i| i.id if i.stage_type=='круг'}
    k = stages_ids.index(stage.id)*team_count
    k == nil? ? 0 : k
  end

  def tour_ring_titles stage
    n = stage.teams.count - 1
    k = tour_correction stage, n
    res = []
    n.times {|i| res << ["#{i+k+1}-й тур", i+k+1] }
    res
  end

  def fetch_card game, from, player_id
    players = (from == "home") ? game.home_players : game.visiting_players
    return :no unless players.blank? || players.include?(player_id)
    return :yellow if game.yellow_cards.present? && game.yellow_cards.include?(player_id)
    return :dbl_yellow if game.dbl_yellow_cards.present? && game.dbl_yellow_cards.include?(player_id)
    return :red if game.red_cards.present? && game.red_cards.include?(player_id)
    return :no
  end

  def fetch_players from, player_id
    @game.send("#{from}_players").present? && @game.send("#{from}_players").include?(player_id)
  end



end
