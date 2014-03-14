class Champ < ActiveRecord::Base
  has_many :players, through: :teams
  has_many :stages
  has_many :teams

  def current_players
    players = []
    teams.each do |team|
      players += team.current_players
    end
    players
  end

  def current_player_ids
    current_players.collect {|i| i.id}
  end



  def self.type
    ['5x5', '8x8', '11x11']
  end

  def self.status
    ['регистрация команд', 'в процессе', 'завершен']
  end


end
