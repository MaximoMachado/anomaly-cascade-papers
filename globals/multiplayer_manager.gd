# class_name MultiplayerManager
extends Node

## Sigals are used for any view to subscribe to multiplayer events

## Signals related to server browser/lobby list
## If players have connected to the server browser
signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)
signal server_disconnected
signal lobbies_recieved(lobbies: Array[Lobby])
signal lobby_joined

## If players have joined a particular lobby
## These get broadcast to all players within a specific lobby
signal player_joined_lobby(player: PlayerInfo)
signal player_left_lobby(peer_id: int)
signal game_config_changed
signal game_started

## In-game signals for actions taken by other players that need to be synced
## TODO: outline of example game signals, would reflect Game interface
signal player_mulliganed(player_id: int)

signal player_played_card(player_id: int)
signal player_activated_ability(player_id: int)
signal player_declared_attacker(player_id: int)
signal player_declared_influencer(player_id: int)
signal player_declared_blocker(player_id: int)

signal player_ended_turn(player_id: int)

signal game_synced

## Server to communicate with that is running this specific lobby/game instance
var SERVER := 1

## Server to communicate with to get a list of joinable lobbies
var SERVER_BROWSER := 1
var SERVER_PORT := 23196 ## Winter-Starling Foundation in numbers
var SERVER_IP := "winter-starling.maximomachado.com" 
var MAX_CLIENTS := 4000

## Client public variables
## These are used for player to keep track of what lobby its in and who they are

## Optional<Lobby>
var joined_lobby: Option = Option.None()

## Optional<Game>
var current_game: Option = Option.None()
## Optional<PlayerInfo>
var client_player_info: Option = Option.None()


## Server variables
## These are all private state

## Used by client to keep track of existing lobbies and 
var _lobbies : Array[Lobby] = []

## Makes easy lookup to see who is host of lobby and is allowed to start lobby
## Type: Dictionary[int, Lobby]
var _host_id_to_lobby: Dictionary = {} 
## Makes easy lookup to see which lobby that player is currently within
## Type: Dictionary[int, Game]
var _player_id_to_lobby: Dictionary = {} 
## Maps lobby IDs that have an on-going started game
## Type: Dictionary[int, Game]
var _lobby_id_to_game: Dictionary = {} 
## Makes easy lookup to find the info associated with player id
## Type: Dictionary[int, PlayerInfo]
var _player_id_to_player_info: Dictionary = {} 

func _validate_internal_invariants() -> void:
	## Invariants: 
	## - For each lobby:
	##		- Lobby ids are unique
	##		- Lobby ids are equal to their host's id
	##		- Lobby's host exists in _host_id_to_lobby and map to lobby
	##		- Lobby's players exist in player_id_lobby and map to lobby
	##		- Player id that exists in lobby must exist in dictionaries with player_id as a key
	##		- No empty lobby exists
	## - For each player:
	##		- Player ids are unique
	##		- They are only mapped to 1 lobby
	if OS.is_debug_build():
		# Todo add invariants to check
		pass

func _ready() -> void:
	pass

## Initializes server
func start_server() -> int:
	var server_peer := ENetMultiplayerPeer.new()
	var error := server_peer.create_server(SERVER_PORT, MAX_CLIENTS)
	if error:
		return error
	multiplayer.multiplayer_peer = server_peer

	multiplayer.peer_connected.connect(_player_connected_to_server)
	multiplayer.peer_disconnected.connect(_player_disconnected_from_server)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	print_debug(multiplayer.get_unique_id())

	return 0


## Initializes client and connects to server
func start_client() -> int:
	var client_peer := ENetMultiplayerPeer.new()
	var error := client_peer.create_client(SERVER_IP, SERVER_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = client_peer

	var id := multiplayer.get_unique_id()
	print_debug(id)

	self.client_player_info = Option.Some(PlayerInfo.new(id, str(id)))
	return 0

## Basic listeners provided by ENetMultiplayerPeer


func _player_connected_to_server(id: int) -> void:
	print("Player connected! Id: %d" % id)
	self._player_id_to_player_info[id] = PlayerInfo.new(id, str(id))
	player_connected.emit(id)

func _player_disconnected_from_server(id: int) -> void:
	print("Player disconnected. Id: %d" % id)
	player_disconnected.emit(id)

func _on_connected_ok() -> void:
	var peer_id := multiplayer.get_unique_id()
	player_connected.emit(peer_id)

func _on_connected_fail() -> void:
	multiplayer.multiplayer_peer = null

func _on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	server_disconnected.emit()

## Helper functions for RPC calls

func _print_debug_rpc_call() -> void:
	if OS.is_debug_build():
		print("RPC Call: %s" % get_stack()[1]["function"])
		print("\tSender: %d" % multiplayer.get_remote_sender_id())
		print("\tReciever: %d\n" % multiplayer.get_unique_id())

## Lobby RPC Requests

## Client -> Server
## Stateless Request
@rpc("any_peer", "reliable")
func server_request_lobbies(num_lobbies: int = 50) -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()
	num_lobbies = clamp(num_lobbies, 0, min(50, _lobbies.size()))

	var page := _lobbies.slice(0, num_lobbies).map(Types.to_dict)
	client_recieve_lobbies.rpc_id(client_id, page)

## Server -> Client
## Stateless Request
## @param p_lobbies : Array[Dictionary]
@rpc("authority", "reliable")
func client_recieve_lobbies(p_lobbies: Array) -> void:
	_print_debug_rpc_call()
	var lobbies : Array[Lobby] = []
	lobbies.assign(p_lobbies.map(Lobby.from_dict))

	lobbies_recieved.emit(lobbies)

## Client -> Server
@rpc("any_peer", "reliable")
func server_request_create_lobby() -> void:
	_print_debug_rpc_call()
	var host_id := multiplayer.get_remote_sender_id()

	# If already in a lobby, can't create a new lobby
	if Option.dict_get(_player_id_to_lobby, host_id).is_some():
		return

	var host_player : PlayerInfo = _player_id_to_player_info[host_id]
	var lobby := Lobby.create(host_player)
	_lobbies.append(lobby)
	_host_id_to_lobby[host_id] = lobby
	_player_id_to_lobby[host_id] = lobby

	client_join_lobby.rpc_id(host_id, lobby.to_dict())

## Client -> Server
@rpc("any_peer", "reliable")
func server_request_join_lobby(lobby_id: int) -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()

	# If already in a lobby, can't join a new lobby
	if Option.dict_get(_player_id_to_lobby, client_id).is_some():
		return

	var lobby : Lobby = _host_id_to_lobby[lobby_id]
	var player : PlayerInfo = _player_id_to_player_info[client_id]
	lobby.add_player(player)
	_player_id_to_lobby[player.id] = lobby

	# Todo: Alert all other clients in lobby that someone has joined
	
	print_debug("Player %d has joined lobby %d" % [player.id, lobby_id])
	client_join_lobby.rpc_id(player.id, lobby.to_dict())

## Server -> Client
## If client joins/creates lobby, on success client is notified
## @param p_lobbies : Array[Dictionary]
@rpc("authority", "reliable")
func client_join_lobby(lobby_dict: Dictionary) -> void:
	_print_debug_rpc_call()
	var lobby: Lobby = Lobby.from_dict(lobby_dict)
	
	self.joined_lobby = Option.Some(lobby)
	lobby_joined.emit()

## Client -> Server
@rpc("any_peer", "reliable")
func server_request_leave_lobby() -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()

	# Can't leave a lobby if not in one
	if Option.dict_get(_player_id_to_lobby, client_id).is_none():
		return

	# Check if player is a host of some lobby
	var in_lobby : Option = Option.dict_get(_host_id_to_lobby, client_id)
	if in_lobby.is_some():
		var lobby : Lobby = in_lobby.unwrap()
		lobby.remove_player(client_id)
		_lobbies.erase(lobby)
		_host_id_to_lobby.erase(client_id)
		_lobby_id_to_game.erase(lobby.id)
	else:
		var lobby : Lobby = Option.dict_get(_player_id_to_lobby, client_id).unwrap()
		lobby.remove_player(client_id)

		# clean-up empty lobby
		if lobby._players.size() == 0:
			_lobbies.erase(lobby)

	# Todo: Alert all other clients in lobby that someone has left
	_player_id_to_lobby.erase(client_id)

	client_leave_lobby.rpc_id(client_id)
	print_debug("Player %d has left lobby" % [client_id])

## Server -> Client
@rpc("authority", "reliable")
func client_leave_lobby() -> void:
	_print_debug_rpc_call()
	self.joined_lobby = Option.None()
	self.current_game = Option.None()

## Lobby Host Client -> Server
@rpc("any_peer", "reliable")
func server_request_start_game() -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()

	# Can't start a lobby if not in one
	if Option.dict_get(_player_id_to_lobby, client_id).is_none():
		return
	
	var is_host_of_lobby : Option = Option.dict_get(_host_id_to_lobby, client_id)
	# Only host can start the lobby
	if is_host_of_lobby.is_some():
		var host_lobby : Lobby = is_host_of_lobby.unwrap()

		# TODO: Replace test decks with letting user set their deck in the lobby
		var test_deck := Deck.new()
		for i in range(50):
			test_deck.shuffle_in_card(Follower.new(str(i), str(i), FollowerStats.new(1, 1, 1)))
			
		for player in host_lobby.players:
			test_deck.shuffle()
			player.deck = test_deck.duplicate()

		var game := Game.new()
		game.start_game(host_lobby)
		_lobby_id_to_game[host_lobby.id] = game
		for player in game.players: # TODO: Remove this once add in RPCs for game actions
			game.mulligan(player.id, [])

		for player in host_lobby.players:
			client_start_game.rpc_id(player.id, game.to_dict_for_player(player.id))
		print_debug("Lobby %d was started by %d" % [host_lobby.id, client_id])
	else:
		print_debug("Lobby was not found for host %d" % [client_id])

## Server -> All Clients in lobby
@rpc("authority", "reliable")
func client_start_game(game_dict: Dictionary) -> void:
	_print_debug_rpc_call()

	self.current_game = Option.Some(Game.from_dict(game_dict))
	game_started.emit()

## RPC calls that relate to Game actions and handling syncing

@rpc("any_peer", "reliable")
func server_request_mulligan(game_dict: Dictionary) -> void:
	pass

func client_mulligan_player() -> void:
	pass
