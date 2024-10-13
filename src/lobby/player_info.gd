

class_name PlayerInfo extends Resource
## Struct containing the basic metadata about who a player is
## Unrelated to the Player in Game class

@export var id: int = 0
@export var user_name: String = ""


func _init(p_id: int, p_user_name: String) -> void:
	id = p_id
	user_name = p_user_name

