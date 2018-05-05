class RecipeManager
  
  def list_all(params)
    params[:limit] ||= 10
    params[:offset] ||= 0
    if params[:name]
      recipes = Recipe.search_by_name(params[:name]).order('created_at DESC').limit(params[:limit]).offset(params[:offset]);
    else
      recipes = Recipe.order('created_at DESC').limit(params[:limit]).offset(params[:offset]);
    end
    
    recipes.map{ |recipe| RecipeRepresenter.new(recipe) }
  end

  def details(params)
    recipe = Recipe.find(params[:id])
    RecipeRepresenter.new(recipe)
  end

  def update(recipe_params)
    recipe = Recipe.new(recipe_params)

    unless is_owner?(recipe)
      raise Exception.new("You are not the owner")
    end

    if recipe.update(recipe_params)
      return RecipeRepresenter.new(recipe)
    end
      raise Exception.new(recipe.erros)
  end

  def create(recipe_params)
    unless validate_params_for_create(recipe_params)
      raise Exception.new("Needs more than one ingredient")
    end

    if Recipe.new(recipe_params.merge(user: current_user)).save
      return RecipeRepresenter.new(recipe)
    else
      raise Exception.new(recipe.erros)
    end
  end

  def delete(params)
    recipe = Recipe.find(params[:id])
    if is_owner?(recipe)
      return recipe.destroy
    end
    raise Exception.new("You are not the owner")
  end

  private
  def is_owner?(recipe)
    recipe.user == current_user
  end
  def validate_params_for_create(recipe_params)
    recipe_params.ingredients_attributes.size > 1
  end
end