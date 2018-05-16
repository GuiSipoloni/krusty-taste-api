require "rails_helper"

RSpec.describe Api::V1::RecipesController, type: :controller do 

  let(:user) { recipe.user}
  let(:recipe) { create(:recipe, name: "cupcake") }
  let(:ingredient) { create(:ingredient, recipe: recipe) }

  describe "GET index" do
    context "has a 200 status" do
      before do
        get :index 
      end
      it { expect(response.status).to eq(200) }
    end

    context "has a 200 status code with filters" do
      before do
        get :index, params: { name: "cupcake" }
      end
      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['summary']['total']).to be_present }
    end

    context "has a summary node with total" do
      before do
        get :index
      end
      it { expect(JSON.parse(response.body)['summary']['total']).to be_present }
    end
  end

  describe "GET private_list" do
    context "has a 200 status but list nothing with user without recipes" do
      before do
        request.headers.merge!(authenticated_header(create(:user, :other_user).id))
        get :private_list 
      end
      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['recipes'].size).to eq(0) }
    end

    context "has a 200 status code using filter and user with recipes" do
      before do
        request.headers.merge!(authenticated_header(user.id))
        get :private_list, params: { name: "cupcake" }
      end
      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['recipes'].size).to eq(1) }
      it { expect(JSON.parse(response.body)['summary']['total']).to be_present }
    end

    context "has a summary node with total" do
      before do
        request.headers.merge!(authenticated_header(create(:user, :other_user).id))
        get :private_list
      end
      it { expect(JSON.parse(response.body)['summary']['total']).to be_present }
    end

    context "has a 401 status code unauthenticated user" do
      before do
        get :private_list
      end
      it { expect(response.status).to eq(401) }
    end
  end

  describe "GET show" do
    context "has a 200 status with a public recipe" do
      before do
        create(:ingredient, recipe: recipe)
        get :show, params: { id: recipe.id }
      end
      it { expect(response.status).to eq(200) }
    end

    context "has a 401 status with a private recipe" do
      before do
        recipe[:public] = false
        recipe.save
        get :show, params: { id: recipe.id }
      end
      it { expect(response.status).to eq(401) }
    end

    context "has a 200 status with a private recipe but user is authenticated" do
      before do
        recipe[:public] = false
        recipe.save
        request.headers.merge!(authenticated_header(user.id))
        get :show, params: { id: recipe.id }
      end
      it { expect(response.status).to eq(200) }
    end

    context "has a 404 status when recipe do not exists" do
      before do
        request.headers.merge!(authenticated_header(user.id))
        get :show, params: { id: 9999 }
      end
      it { expect(response.status).to eq(404) }
    end
  end

  describe "DELETE destroy" do 
    context "has a 200 status when user is authenticated" do
      before do
        request.headers.merge!(authenticated_header(user.id))
        delete :destroy, params: { id: recipe.id }
      end
      it { expect(response.status).to eq(200) }
    end

    context "has a 404 status when recipe do not exists" do
      before do
        request.headers.merge!(authenticated_header(user.id))
        delete :destroy, params: { id: 9999 }
      end
      it { expect(response.status).to eq(404) }
    end

    context "has a 404 status when try delete a recipe that you are not the owner" do
      before do
        request.headers.merge!(authenticated_header(create(:user, :other_user).id))
        delete :destroy, params: { id: recipe.id }
      end
      it { expect(response.status).to eq(404) }
    end
  end

  describe "POST create" do 
    context "has a 201 status and return created object when everything ok" do
      before do
        request.headers.merge!(authenticated_header(create(:user).id))
        post :create, params: load_json("recipe_create")
      end
      it { expect(response.status).to eq(201) }
      it { expect(JSON.parse(response.body)['name']).to eq("krusty burger") }
    end

    context "has a 400 status when recipe don't have the mandatory elements" do
      before do
        request.headers.merge!(authenticated_header(create(:user).id))
        post :create, params: load_json("recipe_create_fail")
      end
      it { expect(response.status).to eq(400) }
    end

    context "has a 400 status when recipe don't have the mandatory elements" do
      before do
        request.headers.merge!(authenticated_header(create(:user).id))
        post :create, params: load_json("recipe_create_one_ingredient")
      end
      it { expect(response.status).to eq(400) }
      it { expect(JSON.parse(response.body)['message']).to eq("Needs more than one ingredient") }
    end
  end

  describe "PUT update" do 
    context "has a 200 status and return updated object when everything ok" do
      before do
        request.headers.merge!(authenticated_header(ingredient.recipe.user.id))
        put :update, params: load_json("recipe_update").merge!(id: ingredient.recipe.id)
      end
      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['name']).to eq("krusty burger with brie") }
      it { expect(JSON.parse(response.body)['ingredients'].pluck('name').include?('brie cheese')).to eq(true) }
    end

    context "has a 404 status when try update a recipe that you are not the owner" do
      before do
        request.headers.merge!(authenticated_header(create(:user, :other_user).id))
        put :update, params: load_json("recipe_update").merge!(id: ingredient.recipe.id)
      end
      it { expect(response.status).to eq(404) }
      it { expect(JSON.parse(response.body)['message']).to eq("Recipe not found") }
    end
  end
end




