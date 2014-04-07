module ApplicationHelper
  def result_points
    {
        win: 3,
        lose: 0,
        draw: 1
    }
  end

  def pretty_date date,format = 'slashes'
    I18n.l date, format: format.to_sym if date.present?
  end

end
