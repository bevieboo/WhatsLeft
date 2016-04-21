require 'sinatra'
require 'carrierwave'

require 'active_record'
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

get '/profile/:id/edit' do
  @user_edit = User.find_by(id: params[:id])
  erb :edit_profile
end

put '/profile/:id/edit' do
  user = User.find_by(id: params[:id])
  user.first_name = params[:first_name]
  user.last_name = params[:last_name]
  user.img_url = params[:img_url]
  if params[:password] == params[:password_confirmation]
    if !params[:password].empty?
      user.password = params[:password]
    end
  end
  user.save
  redirect to "/profile/#{ params[:id] }"
  # erb :edit_profile
end

delete '/profile/:id/edit' do
  user = User.find(params[:id])
  user.destroy
  user.save
  redirect to '/'
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
  @user = User.new
  erb :signup
end

post '/signup' do
  user = User.new
  user.first_name = params[:first_name]
  user.last_name = params[:last_name]
  user.img_url = params[:image]
  user.password = params[:password]
  user.email = params[:email]
  # if params[:password] == params[:password_confirm]
  #   user.password = params[:password]
  # else
  #   flash.now[:error2] = "Oops, that’s not the same password as the first one."
  # end
  # if !User.exists?(email: params[:email])
  #   user.email = params[:email]
  #   if user.save
  #     redirect to '/'
  #   else
  #     raise 'sdfsdf'
  #     @user = user
  #     erb :signup
  #   end
  # else
  #   flash.now[:error] = "Email already exists."
  # end
  if user.save
    redirect to '/'
  else
    @user = user
    erb :signup
  end
end

get '/recipes/new' do
  redirect to '/login' unless logged_in?
  erb :new_recipe
end

get '/recipes/:id' do
  erb :show_recipe
end

get '/recipes' do
  erb :recipes_main
end

post '/recipes' do
  # raise params.inspect
  recipe = Recipe.new
  recipe.name = params[:recipe_name]
  recipe.img_url = params[:image]
  recipe.prep_time = params[:prep_time]
  recipe.cook_time = params[:cook_time]
  recipe.servings = params[:servings]

  if params[:ingredients_name].include?("\r\n")
    arr = params[:ingredients_name].split("\r\n")
    arr.each do |ingredient|
      if !Ingredient.exists?(name: ingredient)
        new_ingredient = Ingredient.create name: ingredient
        recipe.ingredients << new_ingredient
      else
        add_ingredient = Ingredient.find_by(name: ingredient)
        recipe.ingredients << add_ingredient
      end
    end

  else
    if !Ingredient.exists?(name: params[:ingredients_name])
      new_ingredient = Ingredient.create name: params[:ingredients_name]
      recipe.ingredients << new_ingredient
    else
      add_ingredient = Ingredient.find_by(name: params[:ingredients_name])
      recipe.ingredients << add_ingredient
    end
  end

  recipe.directions = params[:directions]
  recipe.user_id = session[:user_id]
  recipe.save
  redirect to '/recipes'

end

get '/recipes/:id/edit' do
  @recipe_edit = Recipe.find(params[:id])
  @ingredients_edit = IngredientRecipe.where(recipe_id: params[:id])
  erb :edit_recipe
end

put '/recipes/:id' do
  recipe_put = Recipe.find(params[:id])
  recipe_put.name = (params[:name])
  recipe_put.img_url = (params[:img_url])
  recipe_put.prep_time = (params[:prep_time])
  recipe_put.cook_time = (params[:cook_time])
  recipe_put.servings = (params[:servings])
  recipe_put.directions = (params[:directions])

  ingredients_put = IngredientRecipe.where(recipe_id: params[:id])

  if params[:ingredients_name].include?("\r\n")
    arr_put = params[:ingredients_name].split("\r\n")
    arr_put.each do |ingredient|
      if !Ingredient.exists?(name: ingredient)
        new_ingredient = Ingredient.create name: ingredient
        ingredients_put.ingredients << new_ingredient
      else
        add_ingredient = Ingredient.find_by(name: ingredient)
        recipe.ingredients << add_ingredient
      end

    end

  else
    if !Ingredient.exists?(name: params[:ingredients_name])
      new_ingredient = Ingredient.create name: params[:ingredients_name]
      recipe.ingredients << new_ingredient
    else
      add_ingredient = Ingredient.find_by(name: params[:ingredients_name])
      recipe.ingredients << add_ingredient
    end
  end

  recipe_put.save
  ingredients_put.save

  redirect to '/profile'
end

get '/results' do
  @ingredients = Ingredient.where(name: params[:search_box])
  @ingredients_id = @ingredients.first.id
  @results = IngredientRecipe.where(ingredient_id: @ingredients_id)
  erb :results
end

# binding.pry
