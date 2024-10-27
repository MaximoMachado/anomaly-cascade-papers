class_name PermanentCard 
extends Card
## Immutable PermanentCard Interface
##
## Represents a Card that when played creates a Permanent that will persist on the Battlefield

## Used for to_dict/from_dict for dynamic dispatch
static var DICT_TYPE := "card.permanent"

## Callable[Permanent]
@export var permanent_spawner: Callable = func() -> Permanent: return Permanent.from_card(self)

## Observer method[br]
## [param return] Returns dictionary representation
func to_dict() -> Dictionary:
	var dict := {}
	dict["dict_type"] = DICT_TYPE
	dict["card_image_path"] = card_image_path
	dict["card_name"] = card_name
	dict["card_text"] = card_text

	return dict

func _init(p_card_name : String = "<Card Name>", p_card_text : String = "<Card Text>") -> void:
	card_name = p_card_name
	card_text = p_card_text
