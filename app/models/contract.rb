class Contract < ActiveRecord::Base
  belongs_to :team
  has_one :champ, through: :team
  belongs_to :player


  scope :active,  -> {where(leave_date: nil)}
  scope :old,  -> {where.not(leave_date: nil)}

  def close
    self.leave_date = Time.now
  end

end
