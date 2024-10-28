
class_name FollowerCard 
extends PermanentCard
## Immutable FollowerCard
##
## Represents a Card that when played creates a Follower that will persist on the Battlefield

static func DICT_TYPE() -> String : return "card.permanent.follower"

## Observer method[br]
## [param return] Returns dictionary representation
func to_dict() -> Dictionary:
	var follower_dict := {}
	follower_dict["dict_type"] = DICT_TYPE
	follower_dict["card_image_path"] = card_image_path
	follower_dict["card_name"] = card_name
	follower_dict["card_text"] = card_text

	return follower_dict

## Creator method[br]
## [param return] Returns dictionary representation
static func from_dict(follower_dict: Dictionary) -> FollowerCard:
	assert(follower_dict["dict_type"] == DICT_TYPE)

	var follower := FollowerCard.new()
	follower.card_image_path = follower_dict["card_image_path"]
	follower.card_name = follower_dict["card_name"]
	follower.card_text = follower_dict["card_text"]

	return follower

func _init(p_card_name : String = "<Card Name>", p_card_text : String = "<Card Text>") -> void:
	card_name = p_card_name
	card_text = p_card_text
