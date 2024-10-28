
class_name Factory
extends Permanent

static func DICT_TYPE() -> String : return "permanent.factory"

func to_dict() -> Dictionary:
	var factory_dict := {}
	factory_dict["dict_type"] = DICT_TYPE

	return factory_dict

static func from_dict(catalyst_dict: Dictionary) -> Factory:
	var factory := Factory.new()
	return factory

## Creator method[br]
static func _from_card(card: FactoryCard) -> Factory:
	return Factory.new()