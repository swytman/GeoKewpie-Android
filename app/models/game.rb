include GamesHelper
class Game < ActiveRecord::Base
  belongs_to :stage
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_id'
  belongs_to :visiting_team, class_name: 'Team', foreign_key: 'visiting_id'
  scope :finished,  -> {where(status: 'finished')}
  scope :scheduled,  -> {where(status: 'scheduled')}
  scope :empty, -> {where(status: 'empty')}

  def self.cards
    {   no: '/pict/no_card.png',
        yellow: '/pict/ico_yellow_card.png',
        dbl_yellow: '/pict/ico_yellow_red_card.png',
        red: '/pict/ico_red_card.png'
    }
  end

  def self.status
    ['empty','scheduled', 'finished']
  end

  def title
    "#{team_title(home_id)} - #{team_title(visiting_id)}"
  end

  def date_text
    if date.nil?
      "?"
    else
      I18n.l(date, format: :long)
    end
  end

  def time_text
    if date.nil? || time.nil?
      "?"
    else
      time.strftime("%H:%M")
    end
  end


  def game_scores
    if visiting_scores.present? && home_scores.present?
      "#{home_scores} : #{visiting_scores}"
    else
      " - : - "
    end
  end





end
