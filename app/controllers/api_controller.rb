class ApiController < ApplicationController
  respond_to :json

  def find_player
    return(head :bad_request) unless params[:term]
    @players = Player.where("lower(surname) LIKE ?", "%#{params[:term].mb_chars.downcase}%")
    items = @players.map do |i|
      {
          label: "#{i.full_name} #{pretty_date i.birthdate,:slashes}",
          value: "#{i.full_name} #{pretty_date i.birthdate,:slashes}",
          player_id: i.id,
          signed: (i.signed_text params[:champ_id].to_i if params[:term].present?)
      }
    end
    render json: items
  end

end