module GamesHelper
  def tours_titles stage
    if stage.stage_type != 'плей-офф'
      tour_ring_titles stage
    else
      tour_play_off_titles
    end
  end

  def tour_play_off_titles
    ['1/64', '1/32', '1/16', '1/8', '1/4', 'полуфинал', 'финал']
  end

  def tour_ring_titles stage
    n = stage.teams.count - 1
    res = []
    n.times {|i| res << "#{i+1}-й тур"}
    res
  end

  def team_title id

    if id.nil?
      return "?"
    else
      begin
        return Team.find(id).title
      rescue
        return "?"
      end
    end
  end

  def fetch_card game, player_id
    return :yellow if game.yellow_cards.present? && game.yellow_cards.include?(player_id)
    return :dbl_yellow if game.dbl_yellow_cards.present? && game.dbl_yellow_cards.include?(player_id)
    return :red if game.red_cards.present? && game.red_cards.include?(player_id)
    return :no
  end



  def fetch_players from, player_id
    @game.send("#{from}_players").present? && @game.send("#{from}_players").include?(player_id)
  end



end
