class DeleteEmptyContracts < ActiveRecord::Migration
  def change
    ids = []
    Contract.all.each do |contract|
      next if contract.player.present? && contract.team.present?
      ids << contract.id
    end
    Contract.where(id: ids).destroy_all

    Champ.all.each do |champ|
      Player.recalculate_players_stats champ, champ.players.map(&:id)
    end
  end
end
