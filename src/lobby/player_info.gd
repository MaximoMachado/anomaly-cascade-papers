

class_name PlayerInfo extends Resource
## Struct containing the basic metadata about who a player is
## Contains bare minimum information a player needs to enter a lobby and start a game

@export var id: int = 0
@export var user_name: String = ""
var deck : Deck = Deck.new()
var influence_deck : Deck = Deck.new()


func _init(p_id: int, p_user_name: String) -> void:
	id = p_id
	user_name = p_user_name

