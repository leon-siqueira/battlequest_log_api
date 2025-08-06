FactoryBot.define do
  factory :player do
    sequence(:logged_id) { |n| "p#{n}" }
    gold { 0 }
    xp { 0 }
    hp { 0 }
    score { 0 }
    level { 1 }
    name { "" }

    trait :player_one do
      logged_id { "p1" }
      gold { 100 }
      xp { 500 }
      hp { 80 }
    end

    trait :player_two do
      logged_id { "p2" }
      gold { 75 }
      xp { 320 }
      hp { 100 }
    end

    trait :player_three do
      logged_id { "p3" }
      gold { 200 }
      xp { 800 }
      hp { 50 }
    end
  end
end
