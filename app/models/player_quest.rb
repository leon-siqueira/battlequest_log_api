class PlayerQuest < ApplicationRecord
  belongs_to :player
  belongs_to :quest

  validates :status, presence: true, inclusion: { in: %w[started completed] }
end
