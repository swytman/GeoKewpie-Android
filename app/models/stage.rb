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
end
