class_name LobbyPanel
extends PanelContainer
## This is a singular panel used within the server browser
## Immutable object, cannot be modified

var lobby: Lobby:
	set(value):
		lobby = value
		%LobbyName.text = "Lobby ID: %d" % lobby.id
		%Players.text = "Players: %d / %d" % [lobby.players.size(), 8]


static func create(lobby: Lobby) -> LobbyPanel:
	var scene : LobbyPanel = load("res://scenes/server_browser/lobby_panel.tscn").instantiate()
	scene.lobby = lobby
	return scene
