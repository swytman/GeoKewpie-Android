class StaticPagesController < ApplicationController

  def week_calendar
    @show_right_panel = true
    week = params[:week].to_i
    @week_number = params[:week].present? ? week : Date.today.strftime("%W").to_i
  end

end
