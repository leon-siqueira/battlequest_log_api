FactoryBot.define do
  factory :logged_event do
    logged_at { '2025-08-04 14:00:00' }
    context { 'GAME' }
    name { 'EVENT' }
    data { '{}' }

    trait :boss_defeat do
      logged_at { '2025-08-04 14:00:27' }
      context { 'COMBAT' }
      name { 'BOSS_DEFEAT' }
      data { '{"boss_name":"GolemKing","defeated_by":"p2","xp":4752,"gold":483}' }
    end

    trait :player_join do
      logged_at { '2025-08-04 14:05:59' }
      context { 'INFO' }
      name { 'PLAYER_JOIN' }
      data { '{"id":"p6","name":"Frank","level":39,"zone":"MysticLake"}' }
    end

    trait :player_death do
      logged_at { '2025-08-04 14:02:17' }
      context { 'COMBAT' }
      name { 'DEATH' }
      data { '{"victim_id":"p3","killer_id":"p1","method":"sword"}' }
    end

    trait :score_update do
      logged_at { '2025-08-04 14:24:19' }
      context { 'GAME' }
      name { 'SCORE' }
      data { '{"player_id":"p3","points":681,"reason":"defeated_monster"}' }
    end

    trait :quest_start do
      logged_at { '2025-08-04 14:02:06' }
      context { 'GAME' }
      name { 'QUEST_START' }
      data { '{"player_id":"p2","quest_id":"q285","name":"Quest q285"}' }
    end

    trait :quest_complete do
      logged_at { '2025-08-04 14:03:45' }
      context { 'GAME' }
      name { 'QUEST_COMPLETE' }
      data { '{"player_id":"p2","quest_id":"q285","reward_xp":1500,"reward_gold":200}' }
    end

    trait :item_pickup do
      logged_at { '2025-08-04 14:09:52' }
      context { 'GAME' }
      name { 'ITEM_PICKUP' }
      data { '{"player_id":"p5","item":"health_potion","qty":9,"location":[90,95]}' }
    end
  end
end
