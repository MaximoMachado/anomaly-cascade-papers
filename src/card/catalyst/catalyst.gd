class_name Catalyst 
extends Card

static var DICT_TYPE = "catalyst"

func to_dict() -> Dictionary:
	var catalyst_dict := {}
	catalyst_dict["dict_type"] = DICT_TYPE
	catalyst_dict["card_image_path"] = card_image_path
	catalyst_dict["card_name"] = card_name
	catalyst_dict["card_text"] = card_text

	return catalyst_dict

static func from_dict(catalyst_dict: Dictionary) -> Catalyst:

	var catalyst := Catalyst.new()
	catalyst.card_image_path = catalyst_dict["card_image_path"]
	catalyst.card_name = catalyst_dict["card_name"]
	catalyst.card_text = catalyst_dict["card_text"]

	return catalyst