class Stage < ActiveRecord::Base
  belongs_to :champ
  has_many :games
  has_many :teams, through: :champ
  attr_accessor :parent_stage

  scope :default_scope,  -> {order(:id)}

  validates :title, presence: true

  def self.type
    ['круг', 'плей-офф']
  end
  def self.status
    ['не начался', 'в процессе', 'завершен']
  end

  def tour_title tour_id
    if stage_type == 'круг'
      return "#{tour_id}-й тур"
    end
    if stage_type == 'плей-офф'
      title = "1/#{tour_id}"
      if tour_id == 1
        title = "финал"
      end
      if tour_id == 2
        title = "полуфинал"
      end
      return title
    end
  end

end
