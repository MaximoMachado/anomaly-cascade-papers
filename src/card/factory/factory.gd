class_name Factory
extends Card

# Used for to_dict/from_dict for dynamic dispatch
static var DICT_TYPE := "factory"

func to_dict() -> Dictionary:
	var factory_dict := {}
	factory_dict["dict_type"] = DICT_TYPE
	factory_dict["card_image"] = card_image.resource_path
	factory_dict["card_name"] = card_name
	factory_dict["card_text"] = card_text

	return factory_dict

static func from_dict(catalyst_dict: Dictionary) -> Factory:

	var factory := Factory.new()
	factory.card_image = catalyst_dict["card_image"]
	factory.card_name = catalyst_dict["card_name"]
	factory.card_text = catalyst_dict["card_text"]

	return factory