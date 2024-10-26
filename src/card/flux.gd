class_name Flux
extends RefCounted

var _flux: Dictionary

func _init() -> void:
	for type: Enums.FluxType in Enums.FluxType.values():
		_flux[type] = 0


func add_flux(flux: Enums.FluxType) -> void:
	_flux[flux] += 1

func to_dict() -> Dictionary:
	return _flux

static func from_dict(flux_dict: Dictionary) -> Flux:
	var flux := Flux.new()
	flux._flux = flux_dict.duplicate()
	return flux