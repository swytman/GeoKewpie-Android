class GameLinkToStages < ActiveRecord::Migration
  def change
    rename_column :games, :champ_id, :stage_id
  end
end
