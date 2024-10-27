

class_name PlayerInfo 
extends Resource
## Struct containing the basic metadata about who a player is
##
## Contains bare minimum information a player needs to enter a lobby and start a game

@export var id: int = 0
@export var user_name: String = ""
@export var deck : Deck = Deck.new()
@export var influence_deck : Deck = Deck.new()


func _init(p_id: int = 0, p_user_name: String = "") -> void:
	id = p_id
	user_name = p_user_name


func to_dict() -> Dictionary:
	var dict := {}
	dict["player_id"] = id
	dict["user_name"] = user_name
	# Todo: Serialize decks

	return dict


static func from_dict(player_info_dict: Dictionary) -> PlayerInfo:
	# Todo: Deserialize decks
	return PlayerInfo.new(player_info_dict["player_id"], player_info_dict["user_name"])
