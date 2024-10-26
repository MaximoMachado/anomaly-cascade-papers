class_name Catalyst 
extends Card

func to_dict() -> Dictionary:
	var catalyst_dict := {}
	catalyst_dict["card_image"] = card_image.resource_path
	catalyst_dict["card_name"] = card_name
	catalyst_dict["card_text"] = card_text

	return catalyst_dict

static func from_dict(catalyst_dict: Dictionary) -> Catalyst:

	var catalyst := Catalyst.new()
	catalyst.card_image = catalyst_dict["card_image"]
	catalyst.card_name = catalyst_dict["card_name"]
	catalyst.card_text = catalyst_dict["card_text"]

	return catalyst