require 'roar/decorator'
require 'roar/json'
class RecipeRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :name
  property :description
  property :public
  property :image
  collection :ingredients, class: Ingredient do
    property :id
    property :name
    property :measurement
  end
  collection :preparation_steps, class: PreparationStep do
    property :id
    property :step
    property :description
  end
  property :user, class: User do 
    property :email
    property :username
  end
end