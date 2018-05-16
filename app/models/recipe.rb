class Recipe < ApplicationRecord
  belongs_to :user

  has_many :ingredients, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :ingredients

  has_many :preparation_steps, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :preparation_steps

  validates_presence_of :name, :description, :image

  scope :by_name, -> (name) { where('name like ?', "%#{name}%") if name.present? }
  scope :publics, -> { where("public = true") }
  scope :by_owner, -> (user) {where('user_id = ?', user) if user.present? }
  scope :desc, -> { order('created_at DESC') }


  def all_publics(params)
    recipes = Recipe.by_name(params[:name]).publics.desc.limit(params[:limit]).offset(params[:offset])
    total = (Recipe.by_name(params[:name]).publics).size

    recipes_representer = { recipes: recipes.map{ |recipe| RecipeRepresenter.new(recipe) } }
    recipes_representer.merge!(add_summary(total))
  end

  def all_privates(params, current_user)
    recipes = Recipe.by_name(params[:name]).by_owner(current_user.id).desc.limit(params[:limit]).offset(params[:offset])
    total = (Recipe.by_name(params[:name]).by_owner(current_user.id)).size

    recipes_representer = { recipes: recipes.map{ |recipe| RecipeRepresenter.new(recipe) } }
    recipes_representer.merge!(add_summary(total))
  end

  def details(id, current_user)
    recipe = Recipe.find(id)
    if recipe.public || recipe.is_owner?(current_user)
      return RecipeRepresenter.new(recipe)
    end
      raise Exceptions::NotOwner.new("You are not the owner")
  end

  def update(recipe_params, current_user)
    recipe = Recipe.by_owner(current_user.id).find(recipe_params[:id])
    recipe.update!(recipe_params)
    RecipeRepresenter.new(recipe)
  end

  def create(recipe_params, current_user)
    recipe = Recipe.new(recipe_params.merge(user: current_user))
    recipe.save!
    RecipeRepresenter.new(recipe)
  end

  def delete(id, current_user)
    recipe = Recipe.by_owner(current_user.id).find(id)
    recipe.destroy
  end

  def is_owner?(current_user)
    user == current_user
  end

  private
    def add_summary(total)
      { summary: { total: total } }
    end
end
