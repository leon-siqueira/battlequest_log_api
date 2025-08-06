class Quest < ApplicationRecord
  validates :logged_id, presence: true, format: { with: /\Aq\d+\z/, message: "must be in the format \"q<numeric_id>\"" }
  validates :xp, :gold, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :player_quests, dependent: :destroy
  has_many :players, through: :player_quests

  before_save :set_id_from_logged_id

  private

  def set_id_from_logged_id
    if logged_id.present?
      self.id = logged_id[1..].to_i
    end
  end
end
