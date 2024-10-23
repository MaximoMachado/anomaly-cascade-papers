extends Control

func _ready():
	MultiplayerManager.start_client()
	MultiplayerManager.lobbies_refreshed.connect(draw)

func draw() -> void:
	for child in %Lobbies.get_children():
		if child is PanelContainer:
			child.queue_free()

	for lobby in MultiplayerManager.lobbies:
		%Lobbies.add_child.call_deferred(make_lobby_panel(lobby))

func make_lobby_panel(lobby: Lobby) -> Node:
	var lobby_id := lobby.lobby_id
	var num_players := lobby.players.size()

	var id_label := Label.new()
	id_label.text = "Lobby ID: %d" % lobby_id

	var num_players_label := Label.new()
	num_players_label.text = "Number of Players: %d" % num_players

	var panel := PanelContainer.new()
	panel.add_child(id_label)
	panel.add_child(num_players_label)
	return panel


func _on_host_pressed() -> void:
	MultiplayerManager.create_lobby.rpc_id(MultiplayerManager.SERVER)

func _on_join_pressed() -> void:
	MultiplayerManager.join_lobby.rpc_id(MultiplayerManager.SERVER, 0)

func _on_refresh_pressed() -> void:
	MultiplayerManager.request_lobbies.rpc_id(MultiplayerManager.SERVER)
