
class_name Factory
extends Permanent

# Used for to_dict/from_dict for dynamic dispatch
static var DICT_TYPE := "permanent.factory"

func to_dict() -> Dictionary:
	var factory_dict := {}
	factory_dict["dict_type"] = DICT_TYPE

	return factory_dict

static func from_dict(catalyst_dict: Dictionary) -> Factory:
	var factory := FactoryCard.new()
	return factory