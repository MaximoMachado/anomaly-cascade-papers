extends Control

func _ready() -> void:
	MultiplayerManager.start_client()
	MultiplayerManager.lobbies_refreshed.connect(draw)

func draw(lobbies: Array[Lobby]) -> void:
	for child in %Lobbies.get_children():
		if child is PanelContainer:
			child.queue_free()

	for lobby: Lobby in lobbies:
		%Lobbies.add_child.call_deferred(LobbyPanel.create(lobby))

func _on_host_pressed() -> void:
	MultiplayerManager.create_lobby.rpc_id(MultiplayerManager.SERVER)

func _on_join_pressed() -> void:
	MultiplayerManager.join_lobby.rpc_id(MultiplayerManager.SERVER, 0)

func _on_refresh_pressed() -> void:
	MultiplayerManager.request_lobbies.rpc_id(MultiplayerManager.SERVER)
