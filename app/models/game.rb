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

  def player_goals player_id
    player_scores.each do |i|
      return i.split('#')[1] if i.split('#')[0].to_i == player_id
    end if player_scores.present?
    return nil
  end

  def player? player_id
    return 1 if home_players.present? && home_players.include?(player_id) ||
                visiting_players.present? && visiting_players.include?(player_id)
    return 0
  end

  def fill_result_ring
    if home_scores > visiting_scores
      home_points = result_points[:win]
      visiting_points = result_points[:lose]
      winner_id = home_id
    elsif home_scores < visiting_scores
      home_points = result_points[:lose]
      visiting_points = result_points[:win]
      winner_id = visiting_id
    elsif home_scores == visiting_scores
      home_points = result_points[:draw]
      visiting_points = result_points[:draw]
      winner_id = 0
    end
  end

  def reset_result
    home_points = nil
    visiting_points = nil
    winner_id = nil
  end





end
