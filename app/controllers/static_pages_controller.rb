class StaticPagesController < ApplicationController

  def week_calendar
    @show_right_panel = true
    week = params[:week].to_i
    year = params[:year].to_i

    @week = params[:week].present? ? week : Date.today.strftime("%W").to_i
    @year = params[:year].present? ? year : Date.today.strftime("%Y").to_i

    if @week > 52
      @week = 1
      @year = @year+1
    end
    if @week < 1
      @week = 52
      @year = @year-1
    end



    if @week == 52
      @next_week = 1
      @next_year = @year+1
    else
      @next_week = @week + 1
      @next_year = @year
    end

    if @week == 1
      @prev_week = 52
      @prev_year = @year-1
    else
      @prev_week = @week - 1
      @prev_year = @year
    end



  end

end
