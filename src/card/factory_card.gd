class_name FactoryCard
extends PermanentCard
## Immutable FactoryCard
##
## Represents a Card that when played creates a Factory that will persist on the Battlefield

static func DICT_TYPE() -> String : return "card.permanent.factory"

func to_dict() -> Dictionary:
	var factory_dict := {}
	factory_dict["dict_type"] = DICT_TYPE
	factory_dict["card_image_path"] = card_image_path
	factory_dict["card_name"] = card_name
	factory_dict["card_text"] = card_text

	return factory_dict

static func from_dict(catalyst_dict: Dictionary) -> FactoryCard:

	var factory := FactoryCard.new()
	factory.card_image_path = catalyst_dict["card_image_path"]
	factory.card_name = catalyst_dict["card_name"]
	factory.card_text = catalyst_dict["card_text"]

	return factory