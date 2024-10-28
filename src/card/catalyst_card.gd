class_name CatalystCard
extends Card

static func DICT_TYPE() -> String : return "card.catalyst"

func to_dict() -> Dictionary:
	var catalyst_dict := {}
	catalyst_dict["dict_type"] = DICT_TYPE
	catalyst_dict["card_image_path"] = card_image_path
	catalyst_dict["card_name"] = card_name
	catalyst_dict["card_text"] = card_text

	return catalyst_dict

static func from_dict(catalyst_dict: Dictionary) -> CatalystCard:

	var catalyst := CatalystCard.new()
	catalyst.card_image_path = catalyst_dict["card_image_path"]
	catalyst.card_name = catalyst_dict["card_name"]
	catalyst.card_text = catalyst_dict["card_text"]

	return catalyst

func _init(p_card_name : String = "<Card Name>", p_card_text : String = "<Card Text>") -> void:
	card_name = p_card_name
	card_text = p_card_text