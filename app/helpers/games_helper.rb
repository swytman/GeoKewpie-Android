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

end
