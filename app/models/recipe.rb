class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :ingredients
  has_many :preparation_steps, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :preparation_steps
end
