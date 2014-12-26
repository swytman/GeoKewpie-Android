module StaticPagesHelper
  def week_dates( year, week_num)

    if week_num<52
      week_num = week_num+1
    else
      week_num = 1
      year = year + 1
    end

    week_start = Date.commercial( year, week_num, 1 )
    week_end = Date.commercial( year, week_num, 7 )
    I18n.l(week_start, format: :month) + ' - ' + I18n.l(week_end, format: :month)
  end

end
