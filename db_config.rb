options = {
  adapter: 'postgresql',
  database: 'whatsleft'
}
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)
