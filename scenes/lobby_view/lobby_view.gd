extends Control
## LobbyView is where the host chooses to start the game
## Players select their decks here for Constructed
## Or players enter draft mode to create decks
## Game Config can be set and modified
## 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _leave_lobby() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/server_browser/server_browser.tscn")


func _on_start_game_pressed() -> void:
	MultiplayerManager.start_lobby()
