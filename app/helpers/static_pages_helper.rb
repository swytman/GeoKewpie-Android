module StaticPagesHelper
  def week_dates( week_num )
    year = Time.now.year
    week_start = Date.commercial( year, week_num, 1 )
    week_end = Date.commercial( year, week_num, 7 )
    I18n.l(week_start, format: :month) + ' - ' + I18n.l(week_end, format: :month)
  end

end
