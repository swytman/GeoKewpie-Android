class Champ < ActiveRecord::Base
  #has_many :players, through: :teams
  has_many :stages
  has_many :teams

  def players
    players = []
    teams.each do |team|
      players += team.players
    end
    players
  end

  def player_ids
    players.collect {|i| i.id}
  end



  def self.type
    ['5x5', '8x8', '11x11']
  end

  def self.status
    ['регистрация команд', 'в процессе', 'завершен']
  end


end
