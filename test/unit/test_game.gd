extends GutTest

## Tests a game of two players with no played cards and just ending turn
func test_two_players_no_cards():
	const player_1 = 0
	const player_2 = 20
	var game := Game.new().add_player(player_1).add_player(player_2)

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

## E2E tests of a game of two players being initialized
func test_two_players_play_cards():

	var test_deck : Deck = Deck.new()
	for i in range(10):
		test_deck.append(Follower.new())
	const player_1 = 0
	const player_2 = 20
	var game := Game.new() \
					.add_player(player_1, test_deck.duplicate(), test_deck.duplicate()) \
					.add_player(player_2, test_deck.duplicate(), test_deck.duplicate())

	assert_eq(game.players.size(), 2)
	game.mulligan(player_1, [])
	game.mulligan(player_2, [])

	# Play phase
	assert_eq(game.game_phase, Enums.GamePhase.PLAY)

	assert_true(game.is_players_turn(player_1))
	assert_false(game.is_players_turn(player_2))

	var player_1_played_card = game.player(player_1).hand.pick_random()
	var player_2_played_card = game.player(player_2).hand.pick_random()

	assert_false(game.play_card(player_2, player_2_played_card, []), "Expected player 2 to not be able to play a card")
	assert_true(game.play_card(player_1, player_1_played_card, []), "Expected player 1 to play a card")

	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	# Declare attackers
	assert_eq(game.game_phase, Enums.GamePhase.DECLARE_ATTACKERS)

	assert_true(game.declare_attacker(player_1, player_1_played_card, player_2))

	assert_false(game.declare_attacker(player_1, player_1_played_card, player_2))
	assert_false(game.declare_attacker(player_2, player_2_played_card, player_1))
	assert_false(game.declare_attacker(player_2, player_2_played_card, player_2))

	assert_false(game.play_card(player_1, game.player(player_1).hand.pick_random(), []), "Did not expected player 1 to play a card")

	assert_false(game.declare_attacker(player_1, Follower.new(), player_2))
		
	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	# Declare blockers
	assert_true(game.is_players_turn(player_2))
	assert_false(game.is_players_turn(player_1))

	assert_true(game.declare_blocker(player_2, player_2_played_card, player_1_played_card), "Expected player 2 to declare blocker")

	assert_false(game.end_turn(player_1))
	assert_true(game.end_turn(player_2))

	# Reaction Phase
	assert_eq(game.game_phase, Enums.GamePhase.REACTION)

	assert_true(game.is_players_turn(player_2))
	assert_false(game.is_players_turn(player_1))

	assert_false(game.play_card(player_1, game.player(player_1).hand.pick_random(), []), "Expected player 1 to not be able to play a card")
	assert_true(game.play_card(player_2, game.player(player_2).hand.pick_random(), []), "Expected player 2 to play a card")

	assert_true(game.play_card(player_1, game.player(player_1).hand.pick_random(), []), "Expected player 1 to be able to play a card")

	assert_false(game.end_turn(player_1))
	assert_true(game.end_turn(player_2))
	assert_false(game.end_turn(player_2))
	assert_true(game.end_turn(player_1))

	assert_eq(game.game_phase, Enums.GamePhase.PLAY)
	assert_true(game.is_players_turn(player_2))
