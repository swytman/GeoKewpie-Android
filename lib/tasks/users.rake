namespace :users do

  desc 'Create base groups'
  task :create_groups => :environment do
    Group.create(key: 'administrators', title: 'Администраторы') if Group.find_by(key: 'administrators').nil?
    puts "Create base groups. Done!"
  end

  desc 'Create administrator account'
  task :create_admin => :environment do
    unless admin = User.find_by(email: 'admin@greenfootball.ru')
      admin = User.new(email: 'admin@greenfootball.ru', password: 'zel123foot', password_confirmation: 'zel123foot')
    end
    admin_group =  Group.find_by(key: 'administrators')
    unless admin.group_ids.include? admin_group.id
      admin.groups << admin_group
      admin.save!(validate: false)
    end
    puts "Create admin user. Done!"
  end

  desc 'Init = call all tasks'
  task :init do
    Rake::Task['users:create_groups'].invoke
    Rake::Task['users:create_admin'].invoke
  end

end