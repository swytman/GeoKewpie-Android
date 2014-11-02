class Champ < ActiveRecord::Base
  LABEL_CSS_SCHEMAS = ['gold', 'platinum', 'bronze', 'green','red']

  has_many :stages
  has_many :games, through: :stages
  has_many :teams

  # игроки с которые в настоящий момент участвуют в сореврновании

  default_scope { order('order_priority DESC') }

  scope :active, -> () {where(status: 'в процессе')}
  scope :alive, -> () { where.not(status: 'завершен') }

  validates :title, presence: true
  validates :group_key, presence: true

  def self.teams_for_contract
    Team.joins(:champ).where.not(champs: {status: 'завершен'}).includes(:champ)
  end

  def self.status
    ['регистрация команд', 'в процессе', 'завершен']
  end

  def group_players
    champs = Champ.where(group_key: group_key)
    t_ids = champs.collect(&:team_ids).flatten
    Contract.active_players_in_teams t_ids
  end

  def players
    Contract.active_players_in_teams team_ids
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

  def week_games current_week
    result = []
    games.each{ |g| result << g if g.date.present? && g.date.strftime("%W").to_i==current_week }
    result
  end

  # полный пересчет результатов матчей
  def fill_all_game_results
    games.each do |game|
      game.fill_result
      game.save
    end
  end

  def full_title
    "#{champ_type} #{title}"
  end

  def self.type
    ['5x5', '8x8', '11x11']
  end






end
