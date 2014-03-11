module StagesHelper
  def ring_games_gen stage
    teams = stage.teams
    n = stage.teams.count
    return unless n.even?
    k = n/2
    team_array = teams.collect {|t| t.id}
    first_team = team_array.shift
    (n-1).times do |i|
      tour_id = i
      if i.even?
        Game.create(home_id: first_team, visiting_id: team_array[0], tour_id: tour_id, stage_id: stage.id)
      else
        Game.create(home_id: team_array[0] , visiting_id: first_team, tour_id: tour_id, stage_id: stage.id)
      end
      (k-1).times do |j|
        Game.create(home_id: team_array[j+1], visiting_id: team_array[n-2-j], tour_id: tour_id, stage_id: stage.id)
      end
      swap = team_array.shift
      team_array << swap
    end
  end

  def ring_games_swap stage, parent_stage_id
    games = Stage.find(parent_stage_id).games
    games.each do |g|
      Game.create(home_id: g.visiting_id, visiting_id: g.home_id, tour_id: g.tour_id, stage_id: stage.id)
    end
  end



end
