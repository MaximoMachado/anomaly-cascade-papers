extends GutTest

## Tests a game of two players being initialized
func test_two_players_no_cards():
	const player_1 = 0
	const player_2 = 20
	var game := Game.new([player_1, player_2], false)
	assert_eq(game.players.size(), 2)
	game.mulligan(player_1, [])
	game.mulligan(player_2, [])

	# Play phase
	assert_eq(game.game_phase, Enums.GamePhase.PLAY)

	assert_true(game.is_players_turn(player_1))
	assert_false(game.is_players_turn(player_2))

	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	# Declare attackers
	assert_eq(game.game_phase, Enums.GamePhase.DECLARE_ATTACKERS)

	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	# Declare blockers
	assert_true(game.is_players_turn(player_2))
	assert_false(game.is_players_turn(player_1))

	assert_false(game.end_turn(player_1))
	assert_true(game.end_turn(player_2))

	# Reaction Phase
	assert_eq(game.game_phase, Enums.GamePhase.REACTION)

	assert_true(game.is_players_turn(player_2))
	assert_false(game.is_players_turn(player_1))

	assert_false(game.end_turn(player_1))
	assert_true(game.end_turn(player_2))
	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	assert_eq(game.game_phase, Enums.GamePhase.PLAY)
	assert_true(game.is_players_turn(player_2))

## Tests a game of two players being initialized
func test_two_players():

	const player_1 = 0
	const player_2 = 20
	var game := Game.new([player_1, player_2], false)
	assert_eq(game.players.size(), 2)
	game.mulligan(player_1, [])
	game.mulligan(player_2, [])

	# Play phase
	assert_eq(game.game_phase, Enums.GamePhase.PLAY)

	assert_true(game.is_players_turn(player_1))
	assert_false(game.is_players_turn(player_2))

	assert_false(game.play_card(player_2, HiddenCard.new(), []), "Expected player 2 to not be able to play a card")
	assert_true(game.play_card(player_1, HiddenCard.new(), []), "Expected player 1 to play a card")

	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	# Declare attackers
	assert_eq(game.game_phase, Enums.GamePhase.DECLARE_ATTACKERS)

	var first_attacker = Follower.new()
	assert_true(game.declare_attacker(player_1, first_attacker, player_2))

	assert_false(game.declare_attacker(player_1, Follower.new(), player_2))
	assert_false(game.declare_attacker(player_2, Follower.new(), player_1))
	assert_false(game.declare_attacker(player_2, Follower.new(), player_2))

	assert_false(game.play_card(player_1, HiddenCard.new(), []), "Expected player 1 to play a card")

	assert_true(game.declare_attacker(player_1, Follower.new(), player_2))
		
	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	# Declare blockers
	assert_true(game.is_players_turn(player_2))
	assert_false(game.is_players_turn(player_1))

	assert_true(game.declare_blocker(player_2, Follower.new(), first_attacker), "Expected player 2 to declare blocker")

	assert_false(game.end_turn(player_1))
	assert_true(game.end_turn(player_2))

	# Reaction Phase
	assert_eq(game.game_phase, Enums.GamePhase.REACTION)

	assert_true(game.is_players_turn(player_2))
	assert_false(game.is_players_turn(player_1))

	assert_false(game.play_card(player_1, HiddenCard.new(), []), "Expected player 1 to not be able to play a card")
	assert_true(game.play_card(player_2, HiddenCard.new(), []), "Expected player 2 to play a card")

	assert_true(game.play_card(player_1, HiddenCard.new(), []), "Expected player 1 to be able to play a card")

	assert_false(game.end_turn(player_1))
	assert_true(game.end_turn(player_2))
	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	assert_eq(game.game_phase, Enums.GamePhase.PLAY)
	assert_true(game.is_players_turn(player_2))
