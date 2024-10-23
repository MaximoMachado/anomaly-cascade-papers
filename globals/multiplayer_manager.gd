# class_name MultiplayerManager
extends Node

## If players have connected to the server browser
signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)
signal server_disconnected
signal lobbies_refreshed

## If players have joined a particular lobby
signal player_joined_lobby(peer_id: int, lobby_id: int)
signal player_left_lobby(peer_id: int, lobby_id: int)
signal game_started(lobby_id: int, game: Game)


const SERVER := 1
# Winter-Starling Foundation in numbers
var SERVER_PORT := 23196 
var SERVER_IP := "winter-starling.maximomachado.com" 
var MAX_CLIENTS := 4000

var lobbies : Array[Lobby] = []
var games: Array[Game] = []

## Makes easy lookup to see who is allowed to start lobby
## Type: Dictionary[int, Lobby]
var host_id_to_lobby: Dictionary = {} 
## Makes easy lookup to see which game that player is currently within
## Type: Dictionary[int, Game]
var player_id_to_game: Dictionary = {} 


func _ready() -> void:
	pass

## Initializes server
func start_server():
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


## Initializes client and connects to server
func start_client():
	var client_peer = ENetMultiplayerPeer.new()
	var error := client_peer.create_client(SERVER_IP, SERVER_PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = client_peer

	print_debug(multiplayer.get_unique_id())


func _player_connected_to_server(id: int):
	print("Player connected! Id: %d" % id)
	player_connected.emit(id)

func _player_disconnected_from_server(id: int):
	print("Player disconnected. Id: %d" % id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	player_connected.emit(peer_id)

func _on_connected_fail():
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	server_disconnected.emit()

func _print_debug_rpc_call():
	if OS.is_debug_build():
		print("RPC Call: %s" % get_stack()[1]["function"])
		print("\tSender: %d" % multiplayer.get_remote_sender_id())
		print("\tReciever: %d\n" % multiplayer.get_unique_id())

## Client -> Server
@rpc("any_peer", "reliable")
func request_lobbies(num_lobbies: int = 50) -> void:
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()
	num_lobbies = clamp(num_lobbies, 0, min(50, lobbies.size()))

	var page := lobbies.slice(0, num_lobbies).map(Types.to_dict)
	set_lobbies.rpc_id(client_id, page)

## Server -> Client
## @param p_lobbies : Array[Dictionary]
@rpc("any_peer", "reliable")
func set_lobbies(p_lobbies: Array) -> void:
	_print_debug_rpc_call()
	lobbies.assign(p_lobbies.map(Lobby.from_dict))
	lobbies_refreshed.emit()


## Client -> Server
@rpc("any_peer", "reliable")
func create_lobby():
	_print_debug_rpc_call()
	var host_id := multiplayer.get_remote_sender_id()

	var lobby := Lobby.new()
	var host_player := PlayerInfo.new(host_id, str(host_id))
	lobby.add_player(host_player)
	lobbies.append(lobby)
	host_id_to_lobby[host_id] = lobby

## Client -> Server
@rpc("any_peer", "reliable")
func join_lobby(lobby_id: int):
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()

	var lobby := lobbies[lobby_id]
	var player := PlayerInfo.new(client_id, str(client_id))
	
	lobby.add_player(player)
	print_debug("Player %d has joined lobby %d" % [player.id, lobby_id])

## Client -> Server
@rpc("any_peer", "reliable")
func leave_lobby():
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()

	var host_lobby : Lobby = host_id_to_lobby.get(client_id)
	if host_lobby != null:
		lobbies.remove_at(lobbies.find(host_lobby))
	else:
		for lobby in lobbies:
			if lobby.has(client_id):
				lobby.remove_player(client_id)
				break

	print_debug("Player %d has left lobby %d" % [client_id])

## Host Client -> Server
@rpc("any_peer", "reliable")
func start_lobby():
	_print_debug_rpc_call()
	var client_id := multiplayer.get_remote_sender_id()
	
	var host_lobby : Lobby = host_id_to_lobby.get(client_id)
	if host_lobby != null:
		var game := Game.new(host_lobby)
		games.append(game)
		for player in host_lobby.players:
			player_id_to_game[player.id] = game

		var lobby_id := lobbies.find(host_lobby)
		lobbies.remove_at(lobby_id)
		host_id_to_lobby.erase(client_id)
		print_debug("Lobby %d was started by %d" % [lobby_id, client_id])

	print_debug("Lobby was not found for host %d" % [client_id])

## Server -> All Clients in lobby
@rpc("authority", "reliable")
func lobby_started():
	_print_debug_rpc_call()
	pass
