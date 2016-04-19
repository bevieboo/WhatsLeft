class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  has_many :ingredient_recipes
  has_many :recipes, through: :ingredient_recipes
end
