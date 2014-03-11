include ApplicationHelper
class Team < ActiveRecord::Base


  has_and_belongs_to_many :players
  has_and_belongs_to_many :champs
  has_many :stages, through: :champs
  has_many :home_games, class_name: "Game", foreign_key: "home_id"
  has_many :visiting_games, class_name: "Game", foreign_key: "visiting_id"

  scope :active,  -> {where(status: 'активна')}
  scope :inactive,  -> {where(status: 'не активна')}


  def self.status
    ['активна', 'не активна']
  end

  def self.calculate_ring id
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
    total_points = win*result_points[:win] + draw*result_points[:draw]
    @team.win, @team.lose, @team.draw, @team.scored, @team.missed, @team.points =  win, lose, draw, scored, missed, total_points
    @team.save!
  end

  def games
    home_games + visiting_games
  end

  def games_in_stage stage_id
    home_games.where(stage_id: stage_id) + visiting_games.where(stage_id: stage_id)
  end


end
