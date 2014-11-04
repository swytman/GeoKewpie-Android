require 'yaml'
require 'fileutils'
namespace 'db' do
  desc 'create production database snapshot'
  task 'snapshot' do
    db_config = YAML.load_file(File.expand_path('config/database.yml', Rails.root))

    dumps_dir = File.expand_path('tmp/snapshots', Rails.root)
    FileUtils.mkpath(dumps_dir) unless Dir.exists?(dumps_dir)

    dttm = Time.now.strftime('%Y%m%d%H%M%S')
    dump_filename = 'snapshot_' + dttm + '.sql'


    database_name = 'snapshot_' + dttm

    dump_to = File.expand_path(dump_filename, dumps_dir)

    cmd = sprintf("pg_dump -h %s -U %s %s > %s",
                  db_config['production']['host'],
                  db_config['production']['username'],
                  db_config['production']['database'],
                  dump_to
    )

    puts "Creating snapshot of production database: #{dump_filename}"
    sh cmd

    puts "Creating snapshot databasese: #{dump_filename}"

    cmd = sprintf 'createdb -h %s -U %s %s',
                  db_config['development']['host'],
                  db_config['development']['username'],
                  database_name
    sh cmd

    puts 'Apply dump'
    cmd  = sprintf 'psql -h %s -U %s %s < %s',
                   db_config['development']['host'],
                   db_config['development']['username'],
                   database_name,
                   dump_to
    sh cmd

    puts "Database: #{database_name}"
    puts 'Done.'
  end



end