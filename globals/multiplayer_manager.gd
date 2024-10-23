# class_name MultiplayerManager
extends Node

## If players have connected to the server browser
signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)
signal server_disconnected
signal lobbies_refreshed(lobbies: Array[Lobby])

## If players have joined a particular lobby
signal host_left_lobby(lobby_id: int)
signal player_joined_lobby(peer_id: int, lobby_id: int)
signal player_left_lobby(peer_id: int, lobby_id: int)
signal game_started(lobby_id: int, game: Game)


## Server Default ID short-hand
const SERVER := 1
## Winter-Starling Foundation in numbers
var SERVER_PORT := 23196 
var SERVER_IP := "winter-starling.maximomachado.com" 
var MAX_CLIENTS := 4000

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
func start_server() -> Error:
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

	return Error.OK


## Initializes client and connects to server
func start_client() -> Error:
	var client_peer := ENetMultiplayerPeer.new()
	var error := client_peer.create_client(SERVER_IP, SERVER_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = client_peer

	print_debug(multiplayer.get_unique_id())

	return Error.OK


func _player_connected_to_server(id: int) -> void:
	print("Player connected! Id: %d" % id)
	_player_id_to_player_info[id] = PlayerInfo.new(id, str(id))
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

func _print_debug_rpc_call() -> void:
	if OS.is_debug_build():
		print("RPC Call: %s" % get_stack()[1]["function"])
		print("\tSender: %d" % multiplayer.get_remote_sender_id())
		print("\tReciever: %d\n" % multiplayer.get_unique_id())

## Client -> Server
@rpc("any_peer", "reliable")
func request_lobbies(num_lobbies: int = 50) -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()
	num_lobbies = clamp(num_lobbies, 0, min(50, _lobbies.size()))

	var page := _lobbies.slice(0, num_lobbies).map(Types.to_dict)
	recieve_lobbies.rpc_id(client_id, page)

## Server -> Client
## @param p_lobbies : Array[Dictionary]
@rpc("any_peer", "reliable")
func recieve_lobbies(p_lobbies: Array) -> void:
	_print_debug_rpc_call()
	lobbies_refreshed.emit(p_lobbies.map(Lobby.from_dict))


## Client -> Server
@rpc("any_peer", "reliable")
func create_lobby() -> void:
	_print_debug_rpc_call()
	var host_id := multiplayer.get_remote_sender_id()

	# If already in a lobby, can't create a new lobby
	if _player_id_to_lobby.get(host_id) == null:
		return

	var lobby := Lobby.new()
	var host_player : PlayerInfo = _player_id_to_player_info[host_id]
	lobby.add_player(host_player)
	_lobbies.append(lobby)
	_host_id_to_lobby[host_id] = lobby

## Client -> Server
@rpc("any_peer", "reliable")
func join_lobby(lobby_id: int) -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()

	# If already in a lobby, can't join a new lobby
	if _player_id_to_lobby.get(client_id) == null:
		return

	var lobby := _lobbies[lobby_id]
	var player := PlayerInfo.new(client_id, str(client_id))
	
	lobby.add_player(player)
	print_debug("Player %d has joined lobby %d" % [player.id, lobby_id])

## Client -> Server
@rpc("any_peer", "reliable")
func leave_lobby() -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()

	var host_lobby : Lobby = _host_id_to_lobby.get(client_id)
	if host_lobby != null:
		_lobbies.remove_at(_lobbies.find(host_lobby))
	else:
		for lobby in _lobbies:
			if lobby.has(client_id):
				lobby.remove_player(client_id)
				break

	print_debug("Player %d has left lobby %d" % [client_id])

## Lobby Host Client -> Server
@rpc("any_peer", "reliable")
func start_lobby() -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()
	
	var host_lobby : Lobby = _host_id_to_lobby.get(client_id)
	if host_lobby != null:
		var game := Game.new(host_lobby)
		_lobby_id_to_game[host_lobby.id] = game

		var lobby_id := _lobbies.find(host_lobby)
		_lobbies.remove_at(lobby_id)
		_host_id_to_lobby.erase(client_id)
		print_debug("Lobby %d was started by %d" % [lobby_id, client_id])

	print_debug("Lobby was not found for host %d" % [client_id])

## Server -> All Clients in lobby
@rpc("authority", "reliable")
func lobby_started() -> void:
	_print_debug_rpc_call()
	pass

## RPC calls that relate to Game actions and handling syncing
