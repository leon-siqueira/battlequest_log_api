class Item < ApplicationRecord
  has_many :player_items, dependent: :destroy
  has_many :players, through: :player_items

  validates :name, presence: true, uniqueness: true
end
