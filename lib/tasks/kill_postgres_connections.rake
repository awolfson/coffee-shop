namespace :db do
  desc 'kills connections to postgres db'
  task :kill_postgres_connections => :environment do
    env = ENV['RAILS_ENV']
    db_config = Rails.configuration.database_configuration[env]
    fail(ArgumentError, "Could not find db config entry for env (#{env})") unless db_config
    db_name = db_config['database']
 
    # thanks to http://stackoverflow.com/questions/12924466/capistrano-with-postgresql-error-database-is-being-accessed-by-other-users
    # previously, we were kill'ing the postgres processes: http://stackoverflow.com/questions/2369744/rails-postgres-drop-error-database-is-being-accessed-by-other-users
    cmd = %(psql -c "SELECT procpid, pg_terminate_backend(pid) as terminated FROM pg_stat_activity WHERE pid <> pg_backend_pid();" -d '#{db_name}')
 
    puts "WARN: killing connections to #{db_name}."
    #puts "  Using:\n  #{cmd}"
 
    unless system(cmd)
      fail $?.inspect
    end
  end
end