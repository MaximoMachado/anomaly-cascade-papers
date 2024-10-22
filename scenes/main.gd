extends Node


## Handles entry-point for server and client code
func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		MultiplayerManager.start_server()
	else:
		get_tree().change_scene_to_file("res://scenes/server_browser/server_browser.tscn")
