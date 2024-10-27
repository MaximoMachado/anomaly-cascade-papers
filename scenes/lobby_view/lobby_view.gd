extends Control
## LobbyView is where the host chooses to start the game
## Players select their decks here for Constructed
## Or players enter draft mode to create decks
## Game Config can be set and modified
## 

func _ready() -> void:
	MultiplayerManager.host_left_lobby.connect(_leave_lobby)
	MultiplayerManager.game_started.connect(_start_game)

	MultiplayerManager.player_joined_lobby.connect(_add_player)
	MultiplayerManager.player_left_lobby.connect(_remove_player)



func _start_game() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/game_view/game_view.tscn")

func _leave_lobby() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/server_browser/server_browser.tscn")

func _on_start_game_pressed() -> void:
	MultiplayerManager.server_request_start_game.rpc_id(MultiplayerManager.SERVER)

func _on_leave_lobby_pressed() -> void:
	MultiplayerManager.server_request_leave_lobby.rpc_id(MultiplayerManager.SERVER)
	_leave_lobby()


func _add_player(player: PlayerInfo) -> void:
	MultiplayerManager.joined_lobby.unwrap().add_player(player)

func _remove_player(player_id: int) -> void:
	var lobby : Lobby = MultiplayerManager.joined_lobby.unwrap()
	var host_left := lobby.host_player_id == player_id
	lobby.remove_player(player_id)

	if host_left:
		_leave_lobby()
