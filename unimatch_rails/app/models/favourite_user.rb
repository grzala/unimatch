class FavouriteUser < ApplicationRecord
  belongs_to :user, :class_name => 'User'
  belongs_to :favourite, :class_name => 'User'
end
