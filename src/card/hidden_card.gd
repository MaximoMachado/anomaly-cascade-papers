
class_name HiddenCard 
extends Card
## Immutable HiddenCard
##
## Card that represents hidden state from the current player
## Can also be used as an empty placeholder

static func DICT_TYPE() -> String : return "card.hidden"

## Overrides init so it does not error
func _init() -> void:
	pass

func to_dict() -> Dictionary:
	return { "dict_type": DICT_TYPE() }

static func from_dict(hidden_card_dict: Dictionary) -> HiddenCard:
	assert(hidden_card_dict["dict_type"] == DICT_TYPE())
	return HiddenCard.new()