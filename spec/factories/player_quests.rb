FactoryBot.define do
  factory :player_quest do
    player { Player.first || create(:player) }
    quest { Quest.first || create(:quest) }
    status { "started" }

    trait :completed do
      status { "completed" }
    end
  end
end
