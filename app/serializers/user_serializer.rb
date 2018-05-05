class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :recipe, :role, :created_at, :updated_at, :last_login
end
