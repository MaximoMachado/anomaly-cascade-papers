# class_name MultiplayerManager
extends Node


# Winter-Starling Foundation in numbers
var SERVER_PORT := 23196 
var SERVER_IP := "127.0.0.1" 

var lobbies : Array[Lobby] = []


func start_server():
	var server_peer := ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = server_peer


	multiplayer.peer_connected.connect(_player_connected_to_server)
	multiplayer.peer_disconnected.connect(_player_disconnected_from_server)
	print_debug(multiplayer.get_unique_id())

func start_client():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer

	print_debug(multiplayer.get_unique_id())


func _player_connected_to_server(id: int):
	print("Player connected! Id: %d" % id)

func _player_disconnected_from_server(id: int):
	print("Player disconnected. Id: %d" % id)
