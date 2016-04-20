require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'carrierwave'

require './console'
require './db_config'
require './models/user'
require './models/ingredient'
require './models/recipe'
require './models/ingredient_recipe'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
    # Will return true if there is a user logged in.
  end
end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  erb :index
end

get '/profile/:id' do
  @user_profile = User.where(id: params[:id])
  @recipes = Recipe.where(user_id: params[:id])
  erb :profile
end

post '/login' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    puts '==========================================='
    puts 'LOGGED IN'
    puts '==========================================='
    redirect to '/'
  else
    erb :index
  end
end

delete '/login' do
  session[:user_id] = nil
  redirect to '/'
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new
  user.first_name = params[:first_name]
  user.last_name = params[:last_name]
  user.img_url = params[:image]
  if params[:password] == params[:password_confirm]
    user.password = params[:password]
  else
    flash.now[:error2] = "Oops, that’s not the same password as the first one."
  end
  if !User.exists?(email: params[:email])
    user.email = params[:email]
    user.save
    redirect to '/'
  else
    flash.now[:error] = "Email already exists."
  end
  erb :signup
end

get '/recipes/new' do
  redirect to '/login' unless logged_in?
  erb :new_recipe
end

get '/recipes/:id' do
  erb :show_recipe
end

get '/recipes' do
  erb :show_recipe
end

post '/recipes' do
  # raise params.inspect
  recipe = Recipe.new
  recipe.name = params[:recipe_name]
  recipe.prep_time = params[:prep_time]
  recipe.cook_time = params[:cook_time]
  recipe.servings = params[:servings]
  if !Ingredient.exists?(name: params[:ingredients_name])
    new_ingredient = Ingredient.create name: params[:ingredients_name]
    recipe.ingredients << new_ingredient
  else
    add_ingredient = Ingredient.find_by(name: params[:ingredients_name])
    recipe.ingredients << add_ingredient
  end
  recipe.directions = params[:directions]
  recipe.user_id = session[:user_id]
  recipe.save
  redirect to '/recipes'
end

get '/results' do
  erb :results
end

# binding.pry
