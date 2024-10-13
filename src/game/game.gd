class_name Game
extends RefCounted


var _game_phase: Enums.GamePhase

## Dictates turn order for _players 
var _players: Array[Player] = []

## Gets a view into the players of the game. Players are mutable but array is not
var players: Array[Player]: 
	get(): return _players.duplicate()
	set(value): _players = Types.read_only(_players, value)

var _id_to_player: Dictionary

var _current_player_id: int

## Dictates which player has the ability to take actions
var current_player_id: int:
	get: return _current_player_id
	set(value): _current_player_id = Types.read_only(_current_player_id, value)

## Used during the Reaction phase to dictate when to end the phase
var _reaction_phase_end_turns_in_a_row: int = 0

## Used solely for the start of the game to determine when it is safe to move to the first turn
## Basically just a set, keys are player ids, values are null
var _mulliganed_players : Dictionary = {}

## Maps initiating attacker (Follower) to a new battle (Battle)
var _battles: Dictionary = {}

## Array of battles that exist
var battles: Array[Battle]:
	get: return _battles.values()
	set(value): _battles = Types.read_only(_battles, value)

var _influencing_followers: Array[Follower] = []

func _init(lobby: Lobby) -> void:
	for player: PlayerInfo in lobby.players:
		var game_player = Player.create_players_with_starting_hand(player.id)
		_players.append(game_player)
	

## Public Mutators

## Start the game object with previously added _players
## Number of _players is equivalent to number of ids
## Turn order is shuffled by default
func start_game(shuffle := true) -> bool:
	assert(_players.size() >= 2, "Game must have at least 2 _players")
	if shuffle:
		_players.shuffle()

	_game_phase = Enums.GamePhase.MULLIGAN
	_current_player_id = _players[0].id

	return true

## Player Actions

## Ends the current turn and goes to the next phase
## Returns whether this is a valid action that can be taken by player
func end_turn(player_id: int) -> bool:
	if not is_players_turn(player_id):
		return false

	match _game_phase:
		Enums.GamePhase.MULLIGAN:
			_game_phase = Enums.GamePhase.PLAY
			_current_player_id = _players[0].id

		Enums.GamePhase.PLAY:
			_game_phase = Enums.GamePhase.DECLARE_ATTACKERS

		Enums.GamePhase.DECLARE_ATTACKERS:
			_game_phase = Enums.GamePhase.DECLARE_BLOCKERS
			_current_player_id = _next_player().id

		Enums.GamePhase.DECLARE_BLOCKERS:
			_game_phase = Enums.GamePhase.REACTION

		Enums.GamePhase.REACTION:
			_reaction_phase_end_turns_in_a_row += 1
			if _end_reaction_phase():
				_reaction_phase_end_turns_in_a_row = 0
				_game_phase = Enums.GamePhase.PLAY
				_end_of_turn_step()

			_current_player_id = _next_player().id
		_:
			push_error("Unhandled GamePhase")

	return true

## One-time mulligan phase to allow _players to choose cards to replace in their starting hand
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
		_game_phase = Enums.GamePhase.PLAY
		_current_player_id = _players[0].id

	return true

func play_card(player_id: int, card: Card, targets: Array[Target] = []) -> bool:
	if not is_players_turn(player_id):
		return false
	
	match _game_phase:
		Enums.GamePhase.PLAY:
			var player : Player = _id_to_player[player_id]
			var index : int = player.hand.find(card)
			if index != -1:
				pass
			else:
				push_error("Player attempted to play card that doesn't exist in their hand")
				return false
		Enums.GamePhase.REACTION:
			_current_player_id = _next_player().id


		_:
			return false

	_reaction_phase_end_turns_in_a_row = 0
	return true


func activate_ability(player_id: int, card: Card, targets: Array[Target] = []) -> bool:
	if not is_players_turn(player_id):
		return false

	match _game_phase:
		Enums.GamePhase.PLAY:
			pass
		Enums.GamePhase.REACTION:
			_current_player_id = _next_player().id

		_:
			return false

	_reaction_phase_end_turns_in_a_row = 0
	return true

func declare_attacker(player_id: int, follower: Follower, target_player: int) -> bool:
	if not is_players_turn(player_id) or player_id == target_player:
		return false

	match _game_phase:
		Enums.GamePhase.DECLARE_ATTACKERS:
			if follower not in _id_to_player[player_id].followers_in_play:
				return false

			if _battles.has(follower):
				_battles.erase(follower)
			else:
				_battles[follower] = Battle.new().add_attacker(follower)
		_:
			return false

	return true

func declare_influencer(player_id: int, follower: Follower) -> bool:
	if not is_players_turn(player_id):
		return false

	match _game_phase:
		Enums.GamePhase.DECLARE_ATTACKERS:
			if follower not in _id_to_player[player_id].followers_in_play:
				return false

			if _influencing_followers.has(follower):
				_influencing_followers.erase(follower)
			else:
				_influencing_followers.append(follower)
		_:
			return false

	return true

func declare_blocker(player_id: int, follower: Follower, attacking_follower: Follower) -> bool:
	if not is_players_turn(player_id):
		return false

	match _game_phase:
		Enums.GamePhase.DECLARE_BLOCKERS:
			if follower not in _id_to_player[player_id].followers_in_play:
				return false

			if _battles.has(attacking_follower):
				if _battles[attacking_follower].find(follower):
					_battles[attacking_follower].remove_blocker(follower)
				else:
					_battles[attacking_follower].add_blocker(follower)
			else:
				return false
		_:
			return false

	return true

## Public Observer methods

## Returns whether it is player's turn to play a card
func is_players_turn(player_id: int) -> bool:
	return _current_player_id == player_id

## Gets reference to player by its ID
func player(player_id: int) -> Player:
	return _id_to_player[player_id].duplicate()

## Producer methods
func duplicate() -> Game:
	pass
	return null

## Private methods

## Orchestrates all of the end of turn steps, deal combat damage, gain influence, etc.
func _end_of_turn_step() -> void:

	for attacker in _battles.keys():
		var battle : Battle = _battles[attacker]
		battle.damage_step()

	for key in _battles.keys():
		var battle : Battle = _battles[key]
		for attacker in battle.attackers:
			if attacker.is_dead():
				## Remove attacker from player zone
				pass

		for blocker in battle.blockers:
			if blocker.is_dead():
				## Remove blocker from player zone
				pass

	# Influence step
	for influencer in _influencing_followers:
		var influence := influencer.influence()
		_id_to_player[_current_player_id].influence += influence

func _next_player() -> Player:
	var current_player_index : int = _players.find(_id_to_player[_current_player_id])
	var next_player_index : int = (current_player_index + 1) % _players.size()
	return _players[next_player_index]

func _previous_player() -> Player:
	var current_player_index : int = _players.find(_id_to_player[_current_player_id])
	# Rolls over automatically thanks to negative Array indexing
	var next_player_index : int = current_player_index - 1
	return _players[next_player_index]

## If all players have passed in a row, then phase ends
func _end_reaction_phase() -> bool:
	return _reaction_phase_end_turns_in_a_row == _players.size()
