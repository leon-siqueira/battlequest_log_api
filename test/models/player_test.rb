# require "test_helper"

# class PlayerTest < ActiveSupport::TestCase
#   test "should not save player without logged_id" do
#     player = Player.new(gold: 0, xp: 0, hp: 0)
#     assert_not player.save, "Saved the player without a logged_id"
#   end

#   test "logged_id must follow the pattern p followed by numbers" do
#     valid_player = Player.new(logged_id: "p123")
#     assert valid_player.valid?, "Valid logged_id format was rejected"

#     invalid_player = Player.new(logged_id: "abc123")
#     assert_not invalid_player.valid?, "Invalid logged_id format was accepted"
#   end

#   test "numeric attributes should not be negative" do
#     player = Player.new(logged_id: "p123", gold: -10)
#     assert_not player.valid?, "Saved with negative gold"

#     player.gold = 0
#     player.xp = -5
#     assert_not player.valid?, "Saved with negative xp"

#     player.xp = 0
#     player.hp = -20
#     assert_not player.valid?, "Saved with negative hp"
#   end

#   test "numeric attributes default to zero" do
#     player = Player.create(logged_id: "p999")
#     assert_equal 0, player.gold
#     assert_equal 0, player.xp
#     assert_equal 0, player.hp
#   end
# end
