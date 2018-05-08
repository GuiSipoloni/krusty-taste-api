class Recipe < ApplicationRecord
  belongs_to :user

  has_many :ingredients, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :ingredients

  has_many :preparation_steps, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :preparation_steps

  validates_presence_of :name, :description

  scope :by_name, -> (name) { where("name like ?", "%#{name}%")}
  scope :publics, -> { where("public = true")}
  scope :privates, -> { where("public = false")}
  scope :owner, -> (user) {where("user_id = ?", user)}

end
