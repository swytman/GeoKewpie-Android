include GamesHelper
class Game < ActiveRecord::Base
  STATUS = ['empty','scheduled', 'finished']
  belongs_to :stage
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_id'
  belongs_to :visiting_team, class_name: 'Team', foreign_key: 'visiting_id'
  scope :finished,  -> {where(status: 'finished')}
  scope :scheduled,  -> {where(status: 'scheduled')}
  scope :empty, -> {where(status: 'empty')}

  # пути к картинка с карточками
  def self.cards
    {   no: '/pict/no_card.png',
        yellow: '/pict/ico_yellow_card.png',
        dbl_yellow: '/pict/ico_yellow_red_card.png',
        red: '/pict/ico_red_card.png'
    }
  end


  #добавлено для избыточности чтобы не вызывать из конслои
  def result_points
    {
        win: 3,
        lose: 0,
        draw: 1
    }
  end

  #cтатус игры

  def text_status
    case self.status
      when 'empty'
        "нет даты"
      when 'scheduled'
        "матч не сыгран"
      when 'finished'
        "матч завершен"
    end
  end


  def title
    "#{team_title(home_id)} - #{team_title(visiting_id)}"
  end

  def date_text format = :default
    if date.nil?
      "?"
    else
      I18n.l(date, format: format)
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
      if home_scores > visiting_scores
        "<span class='green'>#{home_scores}</span> : <span class='red'>#{visiting_scores}</span>".html_safe
      elsif home_scores < visiting_scores
        "<span class='red'>#{home_scores}</span> : <span class='green'>#{visiting_scores}</span>".html_safe
      else
        "<b>#{home_scores}</b> : <b>#{visiting_scores}</b>".html_safe
      end
    else
      " - : - "
    end
  end

  def player_goals player_id, from = nil
    unless from.nil?
      players = (from == "home") ? home_players : visiting_players
      return nil unless players.blank? || players.include?(player_id)
    end
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

  def fill_result
    if stage.stage_type == 'круг'
      fill_result_ring
    end
  end

  def fill_result_ring
    return unless self.status == 'finished'
    if home_scores > visiting_scores
      self.home_points = result_points[:win]
      self.visiting_points = result_points[:lose]
      self.winner_id = home_id
    elsif home_scores < visiting_scores
      self.home_points = result_points[:lose]
      self.visiting_points = result_points[:win]
      self.winner_id = visiting_id
    elsif home_scores == visiting_scores
      self.home_points = result_points[:draw]
      self.visiting_points = result_points[:draw]
      self.winner_id = 0
    end
  end

  def reset_result
    self.home_points = nil
    self.visiting_points = nil
    self.winner_id = nil
  end

end
