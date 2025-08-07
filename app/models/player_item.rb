class PlayerItem < ApplicationRecord
  belongs_to :player
  belongs_to :item

  validates :quantity, presence: true, numericality: { only_integer: true, other_than: 0 }
end
