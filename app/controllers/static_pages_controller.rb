class StaticPagesController < ApplicationController

  def week_calendar
    week = params[:week].to_i
    @week_number = params[:week].present? ? week : Date.today.strftime("%W").to_i
  end

end
