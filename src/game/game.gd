class_name Game
extends RefCounted


var game_phase: Enums.GamePhase

## Dictates turn order for players 
var players: Array[Player] = []
var _id_to_player: Dictionary

## Dictates which player has the ability to take actions
var current_player_id: int

enum PlayerReaction { END_TURN, PLAY_CARD, ACTIVATE_ABILITY }
var _reaction_history : Array[PlayerReaction]

## Used solely for the start of the game to determine when it is safe to move to the first turn
var _mulliganed_players : Dictionary

## Public Mutators

func add_player(player_id: int, main_deck: Deck = Deck.new(), influence_deck: Deck = Deck.new(), team_id: Variant = null) -> Game:

	var player := Player.new(player_id, main_deck, influence_deck)
	players.append(player)
	_id_to_player[player_id] = player

	if team_id != null:
		player.team_id = team_id

	return self

## Start the game object with previously added players
## Number of players is equivalent to number of ids
## Turn order is shuffled by default
func start_game(shuffle := true) -> bool:
	assert(players.size() >= 2, "Game must have at least 2 players")
	if shuffle:
		players.shuffle()

	game_phase = Enums.GamePhase.MULLIGAN
	current_player_id = players[0].id

## Player Actions

## Ends the current turn and goes to the next phase
## Returns whether this is a valid action that can be taken by player
func end_turn(player_id: int) -> bool:
	if not is_players_turn(player_id):
		return false

	match game_phase:
		Enums.GamePhase.MULLIGAN:
			game_phase = Enums.GamePhase.PLAY
			current_player_id = players[0].id

		Enums.GamePhase.PLAY:
			game_phase = Enums.GamePhase.DECLARE_ATTACKERS

		Enums.GamePhase.DECLARE_ATTACKERS:
			game_phase = Enums.GamePhase.DECLARE_BLOCKERS
			current_player_id = _next_player().id

		Enums.GamePhase.DECLARE_BLOCKERS:
			game_phase = Enums.GamePhase.REACTION

		Enums.GamePhase.REACTION:
			_reaction_history.append(PlayerReaction.END_TURN)
			current_player_id = _next_player().id
			if _end_reaction_phase():
				_reaction_history = []
				game_phase = Enums.GamePhase.PLAY
		_:
			push_error("Unhandled GamePhase")

	return true

## One-time mulligan phase to allow players to choose cards to replace in their starting hand
func mulligan(player_id: int, cards: Array[Card]) -> bool:
	# No player turn, everyone does this at the same time
	# If everyone has mulligan, reset and go to Play
	if _mulliganed_players.has(player_id):
		return false

	var player : Player = _id_to_player[player_id]

	# First pass just to verify all cards are there before executing mulligan
	for card in cards:
		var index : int = player.hand.find(card)
		if index == -1:
			return false
		
	for card in cards:
		var index : int = player.hand.find(card)
		assert(index == -1, "Should be impossible that card is not found")
		
		var new_card : Card = player.draw_cards(1)[0]
		player.add_to_hand([new_card])

		player.discard_from_hand([card])
		player.add_to_deck([card])
		

	_mulliganed_players[player_id] = true

	# Start Game if everyone has mulliganed
	if _mulliganed_players.has_all(_id_to_player.keys()):
		game_phase = Enums.GamePhase.PLAY
		current_player_id = players[0].id

	return true

func play_card(player_id: int, card: Card, targets: Array[Target] = []) -> bool:
	if not is_players_turn(player_id):
		return false
	
	match game_phase:
		Enums.GamePhase.PLAY:
			var player : Player = _id_to_player[player_id]
			var index : int = player.hand.find(card)
			if index != -1:
				pass
			else:
				push_error("Player attempted to play card that doesn't exist in their hand")
				return false
		Enums.GamePhase.REACTION:
			current_player_id = _next_player().id


			_reaction_history.append(PlayerReaction.PLAY_CARD)
		_:
			return false

	return true


func activate_ability(player_id: int, card: Card, targets: Array[Target] = []) -> bool:
	if not is_players_turn(player_id):
		return false

	match game_phase:
		Enums.GamePhase.PLAY:
			pass
		Enums.GamePhase.REACTION:
			current_player_id = _next_player().id

			_reaction_history.append(PlayerReaction.ACTIVATE_ABILITY)
		_:
			return false

	return true

func declare_attacker(player_id: int, follower: Follower, target_player: int) -> bool:
	if not is_players_turn(player_id) or player_id == target_player:
		return false

	match game_phase:
		Enums.GamePhase.DECLARE_ATTACKERS:
			pass
		_:
			return false

	return true

func declare_influencer(player_id: int, follower: Follower) -> bool:
	if not is_players_turn(player_id):
		return false

	match game_phase:
		Enums.GamePhase.DECLARE_ATTACKERS:
			pass
		_:
			return false

	return true

func declare_blocker(player_id: int, follower: Follower, attacking_follower: Follower) -> bool:
	if not is_players_turn(player_id):
		return false

	match game_phase:
		Enums.GamePhase.DECLARE_BLOCKERS:
			pass
		_:
			return false

	return true

## Public Observer methods

func is_players_turn(player_id: int) -> bool:
	return current_player_id == player_id

## Private methods

func _next_player() -> Player:
	var current_player_index : int = players.find(_id_to_player[current_player_id])
	var next_player_index : int = (current_player_index + 1) % players.size()
	return players[next_player_index]

func _previous_player() -> Player:
	var current_player_index : int = players.find(_id_to_player[current_player_id])
	# Rolls over automatically thanks to negative Array indexing
	var next_player_index : int = current_player_index - 1
	return players[next_player_index]

## Returns whether the reaction phase should end
func _end_reaction_phase() -> bool:
	var all_players_have_reacted := _reaction_history.size() == players.size() 
	return all_players_have_reacted \
				and _reaction_history.all(func(reaction: PlayerReaction) -> bool: return reaction == PlayerReaction.END_TURN)
