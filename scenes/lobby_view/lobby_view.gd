extends Control
## LobbyView is where the host chooses to start the game
## Players select their decks here for Constructed
## Or players enter draft mode to create decks
## Game Config can be set and modified
## 

var lobby: Lobby = Lobby.new()

func _ready() -> void:
	if MultiplayerManager.joined_lobby != null:
		lobby = MultiplayerManager.joined_lobby
	else:
		push_error("Joined lobby that doesn't exist")
		_leave_lobby()

	MultiplayerManager.host_left_lobby.connect(_leave_lobby)
	MultiplayerManager.game_started.connect(_start_game)

	MultiplayerManager.player_joined_lobby.connect(_add_player)
	MultiplayerManager.player_left_lobby.connect(_remove_player)



func _start_game() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/game_view/game_view.tscn")

func _leave_lobby() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/server_browser/server_browser.tscn")

func _on_start_game_pressed() -> void:
	MultiplayerManager.server_request_start_lobby()

func _on_leave_lobby_pressed() -> void:
	MultiplayerManager.server_request_leave_lobby.rpc_id(MultiplayerManager.SERVER)
	_leave_lobby()


func _add_player(player: PlayerInfo) -> void:
	lobby.add_player(player)

func _remove_player(player_id: int) -> void:
	lobby.remove_player(player_id)
