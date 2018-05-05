require "rails_helper"

RSpec.describe Api::V1::RecipesController, type: :controller do 

  before :all do
    5.times { create(:user_seed) }
    10.times { create(:recipe) }
    20.times { create(:ingredient) }
    20.times { create(:preparation_step) }
  end 

  before :each do
    request.headers.merge!(authenticated_header)
  end

  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    it "has a 200 status code" do
      get :show, params: { id: 1 }
      expect(response.status).to eq(200)
    end
  end

  describe "PUT update" do
    it "has a 200 status code" do
      put :update, params: { id: 1, name: "test update" } 
      expect(response.status).to eq(200)
      expect(response.body[:name]).to eq("test update")
    end
  end

  # describe "GET index" do
  #   it "has a 200 status code" do
  #     get :index
  #     expect(response.status).to eq(200)
  #   end
  # end
end