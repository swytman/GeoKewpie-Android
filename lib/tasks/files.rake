namespace :files do
  desc 'load files from production server'
  task 'import' do
    sh "scp -r -P 17768 swytman@198.199.109.47:/var/www/greenfootball/current/public/system/assets/ #{Rails.public_path.to_s}/system"
  end
end