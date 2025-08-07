class Player < ApplicationRecord
  has_many :player_quests, dependent: :destroy
  has_many :quests, through: :player_quests

  validates :logged_id, presence: true, format: { with: /\Ap\d+\z/, message: "must be in the format \"p<numeric_id>\"" }
  validates :gold, :xp, :hp, :kills, :deaths, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_save :set_id_from_logged_id

  def kdr
    (kills.to_f / (deaths.nonzero? || 1)).round(2)
  end

  private

  def set_id_from_logged_id
    if logged_id.present?
      self.id = logged_id[1..].to_i
    end
  end
end
