class UpdateContracts < ActiveRecord::Migration
  def change
    Rake::Task['calc:contracts'].invoke
  end
end
