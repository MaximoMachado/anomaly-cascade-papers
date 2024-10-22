extends Control



func _on_host_pressed() -> void:
	MultiplayerManager.start_server()


func _on_join_pressed() -> void:
	MultiplayerManager.start_client()
