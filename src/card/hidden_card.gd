
class_name HiddenCard 
extends Card
## Card that represents hidden state from the current player
## Can also be used as an empty placeholder

static var DICT_TYPE := "hidden"

## Overrides init so it does not error
func _init() -> void:
	pass

func to_dict() -> Dictionary:
	return {}

static func from_dict(_hidden_card_dict: Dictionary) -> HiddenCard:
	return HiddenCard.new()