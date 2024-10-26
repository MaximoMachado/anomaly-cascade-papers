class_name CardZone extends RefCounted


enum ZoneType { Factory, Follower, Any }

func to_dict() -> Dictionary:
	var zone_dict := {}
	return zone_dict

static func from_dict(zone_dict: Dictionary) -> CardZone:
	var zone := CardZone.new()
	return zone