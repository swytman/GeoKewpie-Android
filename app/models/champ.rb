class Champ < ActiveRecord::Base
  has_many :stages
  has_and_belongs_to_many :teams


  def self.type
    ['5x5', '8x8', '11x11']
  end

  def self.status
    ['регистрация команд', 'в процессе', 'завершен']
  end


end
