class Contract < ActiveRecord::Base
  belongs_to :team
  has_one :champ, through: :team
  belongs_to :player


  scope :active,  -> {where(leave_date: nil)}
  scope :old,  -> {where.not(leave_date: nil)}

  def close
    self.leave_date = Time.now
  end

  def self.active_players_in_teams t_ids
    ids = Contract.active.where(team_id: t_ids).collect(&:player_id).compact
    Player.where(id: ids)
  end

  def self.old_players_in_teams t_ids
    ids = Contract.old.where(team_id: t_ids).collect(&:player_id).compact
    Player.where(id: ids)
  end

end
