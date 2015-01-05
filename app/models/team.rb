class Team < ActiveRecord::Base
  has_many :contracts
  #has_many :players, through: :contracts
  belongs_to :champ
  belongs_to :team_logo
  has_many :srtages, through: :champs
  has_many :home_games, class_name: "Game", foreign_key: "home_id"
  has_many :visiting_games, class_name: "Game", foreign_key: "visiting_id"

  scope :active,  -> {where(status: ['активна', 'снята'])}
  scope :inactive,  -> {where(status: 'не активна')}

  def old_players
    Contract.old_players_in_teams id
  end

  def players
    Contract.active_players_in_teams id
  end

  def player_ids
    players.collect{|i| i.id}
  end

  def self.logo_path id, size = :standart
    return "nologo.png" if id.nil?
    team = id if id.is_a?(Team)
    team ||= Team.find(id)
    if team.team_logo.present?
      team.team_logo.logo.url(size)
    else
      "nologo.png"
    end
  end

  def self.status
    ['активна', 'не активна', 'снята']
  end

  def self.do_clone champ, gage_team
    new_team = gage_team.dup
    new_team.win, new_team.lose, new_team.draw, new_team.scored, new_team.missed, new_team.points, new_team.penalty_points = 0, 0, 0, 0, 0, 0, 0
    new_team.champ_id = champ.id
    new_team.save
    gage_team.contracts.active.each do |contract|
      new_contract = contract.dup
      new_contract.team_id = new_team.id
      new_contract.games, new_contract.goals, new_contract.y_cards, new_contract.dbl_cards, new_contract.r_cards, new_contract.disq_games = 0, 0, 0, 0, 0, 0
      new_contract.save
    end
  end

  def self.calculate_ring id
    return if id.nil?
    @team = Team.find(id)
    win, lose, draw, scored, missed, total_points = 0, 0, 0, 0, 0, 0
    @team.games.each do |g|
      next unless g.status == 'finished'
      win+=1 if g.winner_id == @team.id
      lose+=1 if g.winner_id != @team.id && g.winner_id != 0 && !g.winner_id.nil?
      draw+=1 if g.winner_id == 0
      if g.home_id == @team.id
        scored += g.home_scores
        missed += g.visiting_scores
      else
        scored += g.visiting_scores
        missed += g.home_scores
      end
    end
    total_points = win*Game.result_points[:win] + draw*Game.result_points[:draw]
    @team.win, @team.lose, @team.draw, @team.scored, @team.missed, @team.points =  win, lose, draw, scored, missed, total_points
    @team.save!
  end

  def games
    home_games + visiting_games
  end

  def games_in_stage stage_id
    home_games.where(stage_id: stage_id) + visiting_games.where(stage_id: stage_id)
  end

  def title_with_champ
    "#{champ.try(:title)}: #{title}"
  end

end
