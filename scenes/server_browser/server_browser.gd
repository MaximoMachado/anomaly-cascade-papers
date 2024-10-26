extends Control

func _ready() -> void:
	MultiplayerManager.start_client()
	MultiplayerManager.lobbies_recieved.connect(draw)

func draw(lobbies: Array[Lobby]) -> void:
	for lobby in lobbies:
		print_debug(lobby.to_dict())
	for child in %Lobbies.get_children():
		if child is LobbyPanel:
			child.lobby_joined.disconnect(_on_join_pressed)
			child.queue_free()

	for lobby: Lobby in lobbies:
		var lobby_panel := LobbyPanel.create(lobby)
		lobby_panel.lobby_joined.connect(_on_join_pressed)
		%Lobbies.add_child.call_deferred(lobby_panel)

func _on_host_pressed() -> void:
	MultiplayerManager.server_create_lobby.rpc_id(MultiplayerManager.SERVER)
	_transition_to_lobby_view()

func _on_refresh_pressed() -> void:
	MultiplayerManager.server_request_lobbies.rpc_id(MultiplayerManager.SERVER)

func _on_join_pressed(lobby_id: int) -> void:
	MultiplayerManager.server_request_join_lobby.rpc_id(MultiplayerManager.SERVER, lobby_id)
	_transition_to_lobby_view()
	
func _transition_to_lobby_view() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/lobby_view/lobby_view.tscn")
