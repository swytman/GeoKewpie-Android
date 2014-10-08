class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :groups

  def admin?
    groups.find_by(key: 'administrators').present?
  end
end
