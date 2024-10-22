extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		MultiplayerManager.start_server()
	else:
		get_tree().change_scene_to_file("res://scenes/lobby_ui/lobby_ui.tscn")
