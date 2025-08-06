FactoryBot.define do
  factory :player_item do
    player { Player.first || create(:player) }
    item { Item.first || create(:item) }
    quantity { 1 }
  end
end
