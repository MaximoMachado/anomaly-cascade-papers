class_name LobbyPanel
extends PanelContainer
## This is a singular panel used within the server browser
## Immutable object, cannot be modified

signal lobby_joined(lobby_id: int)

var lobby : Lobby = Lobby.new():
	set(value):
		lobby = value
		%LobbyName.text = "Lobby ID: %d" % lobby.id
		%Players.text = "Players: %d / %d" % [lobby.players.size(), 8]


static func create(p_lobby: Lobby) -> LobbyPanel:
	var scene : LobbyPanel = load("res://scenes/server_browser/lobby_panel.tscn").instantiate()
	scene.lobby = p_lobby
	return scene


func _on_join_pressed() -> void:
	lobby_joined.emit(lobby.id)
