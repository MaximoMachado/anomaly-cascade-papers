class_name Game
extends RefCounted


var game_phase: Enums.GamePhase

## Dictates turn order for players 
var players: Array[Player]
var _id_to_player: Dictionary

## Dictates which player has the ability to take actions
var current_player_id: int

enum PlayerReaction { END_TURN, PLAY_CARD, ACTIVATE_ABILITY }
var _reaction_history : Array[PlayerReaction]

## Used solely for the start of the game to determine when it is safe to move to the first turn
var _mulliganed_players : Dictionary

## Create a game object with requested player ids
## Number of players is equivalent to number of ids
## Turn order is shuffled by default
func _init(player_ids: Array[int], shuffle: bool = true) -> void:
	assert(player_ids.size() >= 2, "Game must have at least 2 players")

	game_phase = Enums.GamePhase.MULLIGAN
	for i in player_ids:
		var player := Player.new(i)
		players.append(player)
		_id_to_player[i] = player

	if shuffle:
		Algorithms.shuffle(players)
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

func mulligan(player_id: int, cards: Array[Card]) -> bool:
	# No player turn, everyone does this at the same time
	# If everyone has mulligan, reset and go to Play
	if _mulliganed_players.has(player_id):
		return false

	# Todo: Add mulligan logic here

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
			var index = player.hand.find(card)
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
