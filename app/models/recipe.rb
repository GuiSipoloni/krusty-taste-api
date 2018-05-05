class Recipe < ApplicationRecord
  belongs_to :user

  has_many :ingredients, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :ingredients
  
  has_many :preparation_steps, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :preparation_steps

  scope :search_by_name, -> (name) { where("name like ?", "%#{name}%")}

end
