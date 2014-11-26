class AddPlaceToAllGAmes < ActiveRecord::Migration
  def change
    ids = [4, 3, 2]
    Champ.where(id: ids).each do |champ|
      champ.games.update_all(place: 'ФОК "Радуга"')
    end
    ids = [1, 6, 5]
    Champ.where(id: ids).each do |champ|
      champ.games.update_all(place: 'ФОК "Рекорд"')
    end

  end
end
