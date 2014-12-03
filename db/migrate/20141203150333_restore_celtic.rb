class RestoreCeltic < ActiveRecord::Migration
  def change
    Team.find(26).contracts.active.destroy_all
    Team.find(26).contracts.old.update_all(leave_date: nil)
  end
end
