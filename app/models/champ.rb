class Champ < ActiveRecord::Base
  has_many :stages
  has_many :games, through: :stages
  has_many :teams

  # игроки с которые в настоящий момент участвуют в сореврновании

  scope :active, -> () {where(status: 'в процессе')}

  def self.status
    ['регистрация команд', 'в процессе', 'завершен']
  end

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

  # полный пересчет таблицы
  def calculate_table
    stages.each do |stage|
      if stage.stage_type == 'круг'
        stage.teams.each do |team|
        Team.calculate_ring(team.id)
      end
    end
    end
  end

  # полный пересчет результатов матчей
  def fill_all_game_results
    games.each do |game|
      game.fill_result
      game.save
    end
  end


  def self.type
    ['5x5', '8x8', '11x11']
  end




end
