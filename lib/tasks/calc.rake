namespace :calc do

  desc 'recalculate all contracts'

  task :contracts => :environment do
    Contract.all.each do |contact|
      contact.calc [:ignore_disq]
    end
  end

end