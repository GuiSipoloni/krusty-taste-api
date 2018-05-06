class RecipeManager
  
  def list_all_publics(params)
    params[:limit] ||= 10
    params[:offset] ||= 0

    if params[:name]
      recipes = Recipe.by_name(params[:name]).publics.order('created_at DESC').limit(params[:limit]).offset(params[:offset]);
    else
      recipes = Recipe.publics.order('created_at DESC').limit(params[:limit]).offset(params[:offset]);
    end
    
    recipes.map{ |recipe| RecipeRepresenter.new(recipe) }
  end

  def list_all_privates(params, current_user)
    params[:limit] ||= 10
    params[:offset] ||= 0

    if params[:name]
      recipes = Recipe.by_name(params[:name]).owner(current_user.id).order('created_at DESC').limit(params[:limit]).offset(params[:offset]);
    else
      recipes = Recipe.owner(current_user.id).order('created_at DESC').limit(params[:limit]).offset(params[:offset]);
    end
    
    recipes.map{ |recipe| RecipeRepresenter.new(recipe) }
  end

  def details(params)
    recipe = Recipe.find(params[:id])
    RecipeRepresenter.new(recipe)
  end

  def update(recipe_params, current_user)
    recipe = Recipe.find(recipe_params[:id])

    unless is_owner?(recipe, current_user)
      raise Exception.new("You are not the owner")
    end

    if recipe.update(recipe_params)
      return RecipeRepresenter.new(recipe)
    end
      raise Exception.new(recipe.erros)
  end

  def create(recipe_params, current_user)
    unless validate_params_for_create(recipe_params)
      raise Exception.new("Needs more than one ingredient")
    end
    recipe = Recipe.new(recipe_params.merge(user: current_user))
    if recipe.save
      return RecipeRepresenter.new(recipe)
    else
      raise Exception.new(recipe.erros)
    end
  end

  def delete(params, current_user)
    recipe = Recipe.find(params[:id])
    if is_owner?(recipe, current_user)
      return recipe.destroy
    end
    raise Exception.new("You are not the owner")
  end

  private
  def is_owner?(recipe, current_user)
    recipe.user == current_user
  end
  def validate_params_for_create(recipe_params)
    recipe_params[:ingredients_attributes].size > 1
  end
end