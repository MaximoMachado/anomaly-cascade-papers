extends Control

func _ready():
	MultiplayerManager.start_client()

func _process(delta: float) -> void:
	var lobbies := ""
	for lobby in MultiplayerManager.lobbies:
		lobbies += "Lobby:"
		for player in lobby.players:
			lobbies += " Player: %d" % player.id

		lobbies += "\n"

	%LobbyList.text = lobbies
		


func _on_host_pressed() -> void:
	MultiplayerManager.create_lobby.rpc_id(MultiplayerManager.SERVER)

func _on_join_pressed() -> void:
	MultiplayerManager.join_lobby.rpc_id(MultiplayerManager.SERVER, 0)

func _on_refresh_pressed() -> void:
	MultiplayerManager.request_lobbies(MultiplayerManager.SERVER)
