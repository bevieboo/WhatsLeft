require 'pry'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)

require './db_config'
require './models/user'
require './models/ingredient'
require './models/recipe'
require './models/ingredient_recipe'


binding.pry
