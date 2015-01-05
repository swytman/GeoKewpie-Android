module StagesHelper
  def cup_games_gen stage, teams_cnt
    teams_cnt = teams_cnt.to_i
    final_game = stage.games.new({tour_id: 1})
    final_game.save
    create_cup_games_recursive final_game, stage, teams_cnt
  end

  def create_cup_games_recursive target_game, stage, teams_cnt
    current_tour_id = target_game.tour_id * 2
    return if current_tour_id > teams_cnt
    home_game = stage.games.new({tour_id: current_tour_id})
    visiting_game = stage.games.new({tour_id: current_tour_id})
    home_game.save
    visiting_game.save
    target_game.game_visiting_id = visiting_game.id
    target_game.game_home_id = home_game.id
    target_game.save
    create_cup_games_recursive home_game, stage, teams_cnt
    create_cup_games_recursive visiting_game, stage, teams_cnt
  end


  def ring_games_gen stage
    teams = stage.teams
    n = stage.teams.count
    return unless n.even?
    k = n/2
    team_array = teams.collect {|t| t.id}
    first_team = team_array.shift
    (n-1).times do |i|
      tour_id = i+1
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
    n = stage.teams.count - 1
    k = tour_correction stage, n
    games = Stage.find(parent_stage_id).games
    games.order(:tour_id).each do |g|
      Game.create(home_id: g.visiting_id, visiting_id: g.home_id, tour_id: g.tour_id + k, stage_id: stage.id)
    end
  end



end
