class_name Game
extends RefCounted


var game_phase: Enums.GamePhase

var players: Array[Player] ## Dictates turn order for players 
var _id_to_player: Dictionary

var current_player_id: int

enum PlayerReaction { END_TURN, PLAY_CARD, ACTIVATE_ABILITY }
var reaction_history : Array[PlayerReaction]

## Create a game object with requested player ids
## Number of players is equivalent to number of ids
## Turn order is shuffled by default
func _init(player_ids: Array[int]) -> void:
	game_phase = Enums.GamePhase.MULLIGAN
	for i in player_ids:
		var player := Player.new(i)
		players.append(player)
		_id_to_player[i] = player

	Algorithms.shuffle(players)
	current_player_id = players[0].id

## Player Actions

## Ends the current turn and goes to the next phase
## Returns whether this is a valid action that can be taken by player
func end_turn(player_id: int) -> bool:
	if not _is_players_turn(player_id):
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
			# Attacking player gets the first reaction
			current_player_id = _previous_player().id 

		Enums.GamePhase.REACTION:
			reaction_history.append(PlayerReaction.END_TURN)
			current_player_id = _next_player().id
			if _end_reaction_phase():
				reaction_history = []
				game_phase = Enums.GamePhase.PLAY
		_:
			push_error("Unhandled GamePhase")

	return true


func play_card(player_id: int, card: Card, targets: Array[Card]) -> bool:
	if _is_players_turn(player_id):
		return false
	
	match game_phase:
		Enums.GamePhase.PLAY:
			var player : Player = _id_to_player[player_id]
			player.hand.find(card)
		Enums.GamePhase.REACTION:
			current_player_id = _next_player().id
		_:
			return false

	return true


func activate_ability(player_id: int, card: Card, targets: Array[Card]) -> bool:
	if _is_players_turn(player_id):
		return false

	match game_phase:
		Enums.GamePhase.PLAY:
			pass
		Enums.GamePhase.REACTION:
			current_player_id = _next_player().id
		_:
			return false

	return true

func declare_attacker(player_id: int, follower: Follower, target_player: int) -> bool:
	if _is_players_turn(player_id):
		return false

	match game_phase:
		Enums.GamePhase.DECLARE_ATTACKERS:
			pass
		_:
			return false

	return true

func declare_influencer(player_id: int, follower: Follower) -> bool:
	if _is_players_turn(player_id):
		return false

	match game_phase:
		Enums.GamePhase.DECLARE_ATTACKERS:
			pass
		_:
			return false

	return true

func declare_blocker(player_id: int, follower: Follower, attacking_follower: Follower) -> bool:
	if _is_players_turn(player_id):
		return false

	match game_phase:
		Enums.GamePhase.DECLARE_BLOCKERS:
			pass
		_:
			return false

	return true

## Public Observer methods

## Private methods

func _is_players_turn(player_id: int) -> bool:
	return current_player_id == player_id

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
	var all_players_have_reacted := reaction_history.size() == players.size() 
	return all_players_have_reacted \
				and reaction_history.all(func(reaction: PlayerReaction) -> bool: return reaction == PlayerReaction.END_TURN)

## Mutates attacking and defending followers 
func _deal_damage(attackers: Array[Follower], defenders: Array[Follower]) -> void:
	var damage_dealt_to_defenders: Array[int] = []
	damage_dealt_to_defenders.resize(defenders.size())
	damage_dealt_to_defenders.fill(0)
	
	for i in range(attackers.size()):
		var attacker := attackers[i]
		var damage_dealt := attacker.attack(defenders)
		for j in range(damage_dealt.size()):
			damage_dealt_to_defenders[j] += damage_dealt[j]
		
	
	var damage_dealt_to_attackers: Array[int] = []
	damage_dealt_to_attackers.resize(attackers.size())
	damage_dealt_to_attackers.fill(0)
	
	for i in range(defenders.size()):
		var defender := defenders[i]
		var damage_dealt := defender.block(attackers)
		for j in range(damage_dealt.size()):
			damage_dealt_to_attackers[j] += damage_dealt[j]
	
	# Update health of attackers/defenders
	for i in range(attackers.size()):
		attackers[i].recieve_battle_damage(defenders, damage_dealt_to_attackers[i])

	for i in range(defenders.size()):
		defenders[i].recieve_battle_damage(attackers, damage_dealt_to_defenders[i])
